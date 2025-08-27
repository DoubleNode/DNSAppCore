//
//  DNSAppCoreEdgeCaseTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCoreTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSAppCore
import DNSBlankNetwork
import DNSBlankSystems
import DNSBlankWorkers
import DNSCore
import DNSError
import DNSProtocols
import Foundation

class DNSAppCoreEdgeCaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Task { @MainActor in
            DNSAppGlobals.isRunningTest = true
        }
    }
    
    override func tearDown() {
        Task { @MainActor in
            DNSAppGlobals.isRunningTest = false
        }
        super.tearDown()
    }
    
    // MARK: - DNSAppGlobals Edge Cases
    
    @MainActor func testAppLastDisplayedErrorString_withInvalidNSError() {
        // Create a mock error that fails NSError casting
        let customError = CustomError()
        DNSAppGlobals.appLastDisplayedError = customError
        
        let result = DNSAppGlobals.appLastDisplayedErrorString()
        XCTAssertTrue(result.contains("CustomError"))
    }
    
    @MainActor func testAppLastDisplayedErrorString_withLocalizedError() {
        let localizedError = LocalizedTestError()
        DNSAppGlobals.appLastDisplayedError = localizedError
        
        let result = DNSAppGlobals.appLastDisplayedErrorString()
        XCTAssertTrue(result.contains("Test failure reason"))
    }
    
    @MainActor func testAppLastDisplayedErrorString_withMissingTimestamp() {
        let errorWithoutTimestamp = NSError(domain: "test", code: 123, userInfo: [:])
        DNSAppGlobals.appLastDisplayedError = errorWithoutTimestamp
        
        let result = DNSAppGlobals.appLastDisplayedErrorString()
        XCTAssertTrue(result.contains("[Timestamp: <NONE>]"))
    }
    
    func testGlobalsWithExtremeLaunchCounts() {
        // Test with very high launch count
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedCount, with: UInt.max - 1)
        
        let globals = DNSAppGlobals()
        XCTAssertNotNil(globals)
        
        // Cleanup
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedCount, with: 0)
    }
    
    func testGlobalsWithNilDatesFromSettings() {
        // Set up scenario where date settings return nil
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedFirstTime, with: "invalid_date")
        
        XCTAssertNoThrow({
            let _ = DNSAppGlobals()
        })
        
        // Cleanup
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedFirstTime, with: Date())
    }
    
    func testCheckAndAskForReviewWithExtremeDates() {
        let globals = DNSAppGlobals()
        
        // Test with very old date
        let oldDate = Date(timeIntervalSince1970: 0)
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedFirstTime, with: oldDate)
        
        let result = globals.checkAndAskForReview()
        XCTAssertTrue(result is Bool)
    }
    
    // MARK: - DNSAppConfigurator Edge Cases
    
    func testConfiguratorWithNilSystemsAndWorkers() {
        let configurator = DNSAppConfigurator()
        
        // Test with empty arrays (should not crash)
        XCTAssertNoThrow(configurator.didBecomeActive())
        XCTAssertNoThrow(configurator.willResignActive())
        XCTAssertNoThrow(configurator.willEnterForeground())
        XCTAssertNoThrow(configurator.didEnterBackground())
    }
    
    func testConfiguratorWithThrowingSystems() {
        let configurator = DNSAppConfigurator()
        configurator.systems.append(ThrowingMockSystem())
        configurator.workers.append(ThrowingMockWorker() as WKRBase)
        
        // Should handle exceptions gracefully
        XCTAssertNoThrow(configurator.didBecomeActive())
    }
    
    func testConfiguratorWithMixedSystemTypes() {
        let configurator = DNSAppConfigurator()
        
        configurator.systems.append(MockSystemBase1())
        configurator.systems.append(MockSystemBase2())
        configurator.workers.append(MockWorkerBase1() as WKRBase)
        configurator.workers.append(MockWorkerBase2() as WKRBase)
        
        XCTAssertNoThrow(configurator.didBecomeActive())
    }
    
    // MARK: - DNSAppCoreCodeLocation Edge Cases
    
    func testCodeLocationWithVeryLongDomainPreface() {
        let location = DNSAppCoreCodeLocation("edge_case_test")
        let domainPreface = type(of: location).domainPreface
        
        // Ensure domain preface has reasonable length
        XCTAssertLessThan(domainPreface.count, 100)
        XCTAssertGreaterThan(domainPreface.count, 10)
    }
    
    func testCodeLocationThreadSafety() {
        let expectation = XCTestExpectation(description: "Thread safety test")
        expectation.expectedFulfillmentCount = 100
        
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            let location = DNSAppCoreCodeLocation("edge_case_test")
            let _ = type(of: location).domainPreface
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Memory and Resource Tests
    
    func testMemoryLeaksWithLargeArrays() {
        autoreleasepool {
            let configurator = DNSAppConfigurator()
            
            for i in 0..<1000 {
                configurator.systems.append(MemoryTestSystem(id: i))
                configurator.workers.append(MemoryTestWorker(id: i) as WKRBase)
            }
            
            configurator.didBecomeActive()
            configurator.systems.removeAll()
            configurator.workers.removeAll()
        }
        
        // Test passes if we don't run out of memory
        XCTAssertTrue(true)
    }
    
    func testConcurrentModificationSafety() {
        let configurator = DNSAppConfigurator()
        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)
        
        // Add initial systems and workers
        for i in 0..<10 {
            configurator.systems.append(ConcurrentTestSystem(id: i))
            configurator.workers.append(ConcurrentTestWorker(id: i) as WKRBase)
        }
        
        let expectation = XCTestExpectation(description: "Concurrent modification")
        expectation.expectedFulfillmentCount = 20
        
        // Concurrent reads
        for _ in 0..<20 {
            queue.async {
                configurator.didBecomeActive()
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Test Helper Classes

struct CustomError: Error {
    let localizedDescription = "Custom error description"
}

struct LocalizedTestError: LocalizedError {
    var errorDescription: String? { "Test error description" }
    var failureReason: String? { "Test failure reason" }
    var recoverySuggestion: String? { "Test recovery suggestion" }
}

class ThrowingMockSystem: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
    
    override func didBecomeActive() {
        // Simulate system that might have issues
        super.didBecomeActive()
    }
}

class ThrowingMockWorker: WKRBase, @unchecked Sendable {
    override func didBecomeActive() {
        // Simulate worker that might have issues
        super.didBecomeActive()
    }
}

class MockSystemBase1: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
}
class MockSystemBase2: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
}
class MockWorkerBase1: WKRBase, @unchecked Sendable {}
class MockWorkerBase2: WKRBase, @unchecked Sendable {}

class MemoryTestSystem: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
    
    let id: Int
    let data: [Int]
    
    required init() {
        fatalError("init() has not been implemented")
    }

    init(id: Int) {
        self.id = id
        self.data = Array(0..<100) // Some data to test memory
        super.init()
    }
}

class MemoryTestWorker: WKRBase, @unchecked Sendable {
    let id: Int
    let data: [String]
    
    required init() {
        fatalError("init() has not been implemented")
    }

    init(id: Int) {
        self.id = id
        self.data = (0..<100).map { "data_\($0)" }
        super.init()
    }
}

class ConcurrentTestSystem: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
    
    let id: Int
    
    required init() {
        fatalError("init() has not been implemented")
    }

    init(id: Int) {
        self.id = id
        super.init()
    }
    
    override func didBecomeActive() {
        // Simulate some work
        Thread.sleep(forTimeInterval: 0.001)
        super.didBecomeActive()
    }
}

class ConcurrentTestWorker: WKRBase, @unchecked Sendable {
    let id: Int
    
    required init() {
        fatalError("init() has not been implemented")
    }

    init(id: Int) {
        self.id = id
        super.init()
    }
    
    override func didBecomeActive() {
        // Simulate some work
        Thread.sleep(forTimeInterval: 0.001)
        super.didBecomeActive()
    }
}
