//
//  DNSAppCorePerformanceTests.swift
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

class DNSAppCorePerformanceTests: XCTestCase {
    
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
    
    func testConfiguratorPerformanceWithManySystems() {
        let configurator = DNSAppConfigurator()
        
        // Add 100 systems
        for _ in 0..<100 {
            configurator.systems.append(PerformanceTestSystem() as! (any SYSPTCLSystemBase))
        }
        
        measure {
            configurator.didBecomeActive()
        }
    }
    
    func testConfiguratorPerformanceWithManyWorkers() {
        let configurator = DNSAppConfigurator()
        
        // Add 100 workers
        for _ in 0..<100 {
            configurator.workers.append(PerformanceTestWorker() as WKRBase)
        }
        
        measure {
            configurator.didBecomeActive()
        }
    }
    
    func testGlobalsInitializationPerformance() {
        measure {
            for _ in 0..<100 {
                let _ = DNSAppGlobals()
            }
        }
    }
    
    @MainActor func testErrorStringGenerationPerformance() {
        let testError = NSError(domain: "performance.test", code: 500, userInfo: [
            "DNSTimeStamp": "2024-01-01T00:00:00Z",
            "additionalInfo": "This is a test error with additional information"
        ])
        DNSAppGlobals.appLastDisplayedError = testError
        
        measure {
            for _ in 0..<1000 {
                let _ = DNSAppGlobals.appLastDisplayedErrorString()
            }
        }
    }
    
    func testCodeLocationCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                let _ = DNSAppCoreCodeLocation("test")
            }
        }
    }
    
    func testCheckAndAskForReviewPerformance() {
        let globals = DNSAppGlobals()
        
        measure {
            for _ in 0..<50 {
                let _ = globals.checkAndAskForReview()
            }
        }
    }
    
    func testFullLifecyclePerformance() {
        let configurator = DNSAppConfigurator()
        
        // Add moderate number of systems and workers
        for _ in 0..<10 {
            configurator.systems.append(PerformanceTestSystem() as! (any SYSPTCLSystemBase))
            configurator.workers.append(PerformanceTestWorker() as WKRBase)
        }
        
        measure {
            configurator.didBecomeActive()
            configurator.willResignActive()
            configurator.willEnterForeground()
            configurator.didEnterBackground()
        }
    }
    
    func testConcurrentConfiguratorAccess() {
        let configurator = DNSAppConfigurator()
        for _ in 0..<20 {
            configurator.systems.append(PerformanceTestSystem())
            configurator.workers.append(PerformanceTestWorker() as WKRBase)
        }
        
        measure {
            DispatchQueue.concurrentPerform(iterations: 10) { _ in
                configurator.didBecomeActive()
                configurator.willResignActive()
            }
        }
    }
    
    @MainActor func testStaticPropertyAccessPerformance() {
        measure {
            for _ in 0..<10000 {
                let _ = DNSAppGlobals.debugStartupString
                let _ = DNSAppGlobals.dynamicLinkUrlString
                let _ = DNSAppGlobals.shouldForceLogout
                let _ = DNSAppGlobals.isRunningTest
            }
        }
    }
}

// MARK: - Performance Test Classes
class PerformanceTestSystem: SYSBlankSystem, SYSPTCLSystemBase {
    var netConfig: any DNSProtocols.NETPTCLConfig = NETBlankConfig()
    
    override func didBecomeActive() {
        // Simulate minimal work
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    override func willEnterForeground() {
        super.willEnterForeground()
    }
    
    override func didEnterBackground() {
        super.didEnterBackground()
    }
}

class PerformanceTestWorker: WKRBase, @unchecked Sendable {
    override func didBecomeActive() {
        // Simulate minimal work
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    override func willEnterForeground() {
        super.willEnterForeground()
    }
    
    override func didEnterBackground() {
        super.didEnterBackground()
    }
}
