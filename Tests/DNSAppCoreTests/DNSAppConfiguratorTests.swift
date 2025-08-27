//
//  DNSAppConfiguratorTests.swift
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
import DNSProtocols

class DNSAppConfiguratorTests: XCTestCase {
    private var sut: DNSAppConfigurator!
    private var mockSystem: MockSystem!
    private var mockWorker: MockWorker!
    
    override func setUp() {
        super.setUp()
        sut = DNSAppConfigurator()
        mockSystem = MockSystem()
        mockWorker = MockWorker()
    }
    
    override func tearDown() {
        sut = nil
        mockSystem = nil
        mockWorker = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut.systems.isEmpty)
        XCTAssertTrue(sut.workers.isEmpty)
    }
    
    func testSystemsAndWorkersArrays() {
        sut.systems.append(mockSystem!)
        sut.workers.append(mockWorker as WKRBase)
        
        XCTAssertEqual(sut.systems.count, 1)
        XCTAssertEqual(sut.workers.count, 1)
    }
    
    func testDidBecomeActive() {
        sut.systems.append(mockSystem!)
        sut.workers.append(mockWorker as WKRBase)
        
        sut.didBecomeActive()
        
        XCTAssertTrue(mockSystem.didBecomeActiveCalled)
        XCTAssertTrue(mockWorker.didBecomeActiveCalled)
    }
    
    func testWillResignActive() {
        sut.systems.append(mockSystem!)
        sut.workers.append(mockWorker as WKRBase)
        
        sut.willResignActive()
        
        XCTAssertTrue(mockSystem.willResignActiveCalled)
        XCTAssertTrue(mockWorker.willResignActiveCalled)
    }
    
    func testWillEnterForeground() {
        sut.systems.append(mockSystem!)
        sut.workers.append(mockWorker as WKRBase)
        
        sut.willEnterForeground()
        
        XCTAssertTrue(mockSystem.willEnterForegroundCalled)
        XCTAssertTrue(mockWorker.willEnterForegroundCalled)
    }
    
    func testDidEnterBackground() {
        sut.systems.append(mockSystem!)
        sut.workers.append(mockWorker as WKRBase)
        
        sut.didEnterBackground()
        
        XCTAssertTrue(mockSystem.didEnterBackgroundCalled)
        XCTAssertTrue(mockWorker.didEnterBackgroundCalled)
    }
    
    func testProtocolConformance() {
        XCTAssertNotNil(sut)
    }
    
    func testLifecycleMethodsWithEmptyArrays() {
        XCTAssertNoThrow(sut.didBecomeActive())
        XCTAssertNoThrow(sut.willResignActive())
        XCTAssertNoThrow(sut.willEnterForeground())
        XCTAssertNoThrow(sut.didEnterBackground())
    }
    
    func testMultipleSystemsAndWorkers() {
        let mockSystem2 = MockSystem()
        let mockWorker2 = MockWorker()
        
        sut.systems.append(contentsOf: [mockSystem!, mockSystem2])
        sut.workers.append(contentsOf: [mockWorker as WKRBase, mockWorker2 as WKRBase])
        
        sut.didBecomeActive()
        
        XCTAssertTrue(mockSystem.didBecomeActiveCalled)
        XCTAssertTrue(mockSystem2.didBecomeActiveCalled)
        XCTAssertTrue(mockWorker.didBecomeActiveCalled)
        XCTAssertTrue(mockWorker2.didBecomeActiveCalled)
    }
}

// MARK: - Mock Classes
class MockSystem: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
    
    var didBecomeActiveCalled = false
    var willResignActiveCalled = false
    var willEnterForegroundCalled = false
    var didEnterBackgroundCalled = false
    
    override func didBecomeActive() {
        didBecomeActiveCalled = true
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        willResignActiveCalled = true
        super.willResignActive()
    }
    
    override func willEnterForeground() {
        willEnterForegroundCalled = true
        super.willEnterForeground()
    }
    
    override func didEnterBackground() {
        didEnterBackgroundCalled = true
        super.didEnterBackground()
    }
}

class MockWorker: WKRBase, @unchecked Sendable {
    var didBecomeActiveCalled = false
    var willResignActiveCalled = false
    var willEnterForegroundCalled = false
    var didEnterBackgroundCalled = false
    
    override func didBecomeActive() {
        didBecomeActiveCalled = true
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        willResignActiveCalled = true
        super.willResignActive()
    }
    
    override func willEnterForeground() {
        willEnterForegroundCalled = true
        super.willEnterForeground()
    }
    
    override func didEnterBackground() {
        didEnterBackgroundCalled = true
        super.didEnterBackground()
    }
}
