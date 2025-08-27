//
//  DNSAppCoreIntegrationTests.swift
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

class DNSAppCoreIntegrationTests: XCTestCase {
    private var configurator: DNSAppConfigurator!
    private var globals: DNSAppGlobals!
    
    override func setUp() {
        super.setUp()
        Task { @MainActor in
            DNSAppGlobals.isRunningTest = true
        }
        configurator = DNSAppConfigurator()
        globals = DNSAppGlobals()
    }
    
    override func tearDown() {
        configurator = nil
        globals = nil
        Task { @MainActor in
            DNSAppGlobals.isRunningTest = false
        }
        super.tearDown()
    }
    
    func testFullAppLifecycleIntegration() {
        // Setup systems and workers
        let mockSystem = MockSystemIntegration()
        let mockWorker = MockWorkerIntegration()
        
        configurator.systems.append(mockSystem)
        configurator.workers.append(mockWorker as WKRBase)
        
        // Test complete lifecycle
        configurator.didBecomeActive()
        configurator.willResignActive()
        configurator.willEnterForeground()
        configurator.didEnterBackground()
        
        // Verify all methods were called
        XCTAssertTrue(mockSystem.allMethodsCalled)
        XCTAssertTrue(mockWorker.allMethodsCalled)
    }
    
    func testGlobalsAndConfiguratorIntegration() {
        // Test that globals and configurator can work together
        globals.applicationDidBecomeActive()
        configurator.didBecomeActive()
        
        globals.applicationWillResignActive()
        configurator.willResignActive()
        
        // Should not crash or conflict
        XCTAssertNotNil(globals)
        XCTAssertNotNil(configurator)
    }
    
    @MainActor func testErrorHandlingIntegration() {
        let testError = NSError(domain: "test.integration", code: 500, userInfo: [
            "DNSTimeStamp": "2024-01-01T00:00:00Z"
        ])
        
        DNSAppGlobals.appLastDisplayedError = testError
        let errorString = DNSAppGlobals.appLastDisplayedErrorString()
        
        XCTAssertTrue(errorString.contains("test.integration"))
        XCTAssertTrue(errorString.contains("2024-01-01T00:00:00Z"))
    }
    
    func testCodeLocationIntegration() {
        let location = DNSAppCoreCodeLocation("integration_test")
        let domainPreface = type(of: location).domainPreface
        
        // Test integration with error creation
        XCTAssertEqual(domainPreface, "com.doublenode.appCore.")
        XCTAssertTrue(domainPreface.contains("appCore"))
    }
    
    func testReviewWorkflowIntegration() {
        // Test the review request workflow
        let result = globals.checkAndAskForReview()
        
        // Should return a boolean without crashing
        XCTAssertTrue(result is Bool)
    }
    
    func testConcurrentAccess() {
        let expectation = XCTestExpectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            let localGlobals = DNSAppGlobals()
            let localConfigurator = DNSAppConfigurator()
            
            localConfigurator.didBecomeActive()
            localGlobals.applicationDidBecomeActive()
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testMemoryManagement() {
        weak var weakConfigurator: DNSAppConfigurator?
        weak var weakGlobals: DNSAppGlobals?
        
        autoreleasepool {
            let tempConfigurator = DNSAppConfigurator()
            let tempGlobals = DNSAppGlobals()
            
            weakConfigurator = tempConfigurator
            weakGlobals = tempGlobals
            
            // Use the objects
            tempConfigurator.didBecomeActive()
            tempGlobals.applicationDidBecomeActive()
        }
        
        // Objects should be deallocated
        XCTAssertNil(weakConfigurator)
        XCTAssertNil(weakGlobals)
    }
}

// MARK: - Mock Classes for Integration Tests
class MockSystemIntegration: SYSBlankSystem, SYSPTCLSystem {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
    
    private var methodCallCount = 0
    private let expectedCallCount = 4
    
    var allMethodsCalled: Bool {
        return methodCallCount == expectedCallCount
    }
    
    override func didBecomeActive() {
        methodCallCount += 1
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        methodCallCount += 1
        super.willResignActive()
    }
    
    override func willEnterForeground() {
        methodCallCount += 1
        super.willEnterForeground()
    }
    
    override func didEnterBackground() {
        methodCallCount += 1
        super.didEnterBackground()
    }
}

class MockWorkerIntegration: WKRBase, @unchecked Sendable {
    private var methodCallCount = 0
    private let expectedCallCount = 4
    
    var allMethodsCalled: Bool {
        return methodCallCount == expectedCallCount
    }
    
    override func didBecomeActive() {
        methodCallCount += 1
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        methodCallCount += 1
        super.willResignActive()
    }
    
    override func willEnterForeground() {
        methodCallCount += 1
        super.willEnterForeground()
    }
    
    override func didEnterBackground() {
        methodCallCount += 1
        super.didEnterBackground()
    }
}
