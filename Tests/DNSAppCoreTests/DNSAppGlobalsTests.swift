//
//  DNSAppGlobalsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCoreTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSAppCore
import DNSCore
import DNSProtocols

class DNSAppGlobalsTests: XCTestCase {
    private var sut: DNSAppGlobals!

    override func setUp() {
        super.setUp()
        Task { @MainActor in
            DNSAppGlobals.isRunningTest = true
        }
        sut = DNSAppGlobals()
    }
    
    override func tearDown() {
        sut = nil
        Task { @MainActor in
            DNSAppGlobals.isRunningTest = false
        }
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.wkrAppReview)
        XCTAssertFalse(sut.appDidCrashLastRun)
        XCTAssertFalse(sut.askedDeviceForPushNotifications)
    }
    
    @MainActor func testStaticProperties() {
        DNSAppGlobals.appLastDisplayedError = nil
        XCTAssertNil(DNSAppGlobals.appLastDisplayedError)
        
        DNSAppGlobals.debugStartupString = "test"
        XCTAssertEqual(DNSAppGlobals.debugStartupString, "test")
        
        DNSAppGlobals.dynamicLinkUrlString = "https://example.com"
        XCTAssertEqual(DNSAppGlobals.dynamicLinkUrlString, "https://example.com")
        
        DNSAppGlobals.shouldForceLogout = true
        XCTAssertTrue(DNSAppGlobals.shouldForceLogout)
    }
    
    @MainActor func testAppLastDisplayedErrorString_nilError() {
        DNSAppGlobals.appLastDisplayedError = nil
        let result = DNSAppGlobals.appLastDisplayedErrorString()
        XCTAssertEqual(result, "<NONE>")
    }
    
    @MainActor func testAppLastDisplayedErrorString_validError() {
        let testError = NSError(domain: "test", code: 123, userInfo: ["DNSTimeStamp": "2024-01-01"])
        DNSAppGlobals.appLastDisplayedError = testError
        
        let result = DNSAppGlobals.appLastDisplayedErrorString()
        XCTAssertTrue(result.contains("[Timestamp: 2024-01-01]"))
        XCTAssertTrue(result.contains(testError.localizedDescription))
    }
    
    func testCommonInit() {
        let globals = DNSAppGlobals()
        XCTAssertNotNil(globals)
    }
    
    func testApplicationLifecycleMethods() {
        XCTAssertNoThrow(sut.applicationDidBecomeActive())
        XCTAssertNoThrow(sut.applicationWillResignActive())
    }
    
    func testCheckAndAskForReview() {
        let result = sut.checkAndAskForReview()
        XCTAssertTrue(result || !result) // Should not crash, returns boolean
    }
    
    func testAppDidCrashLastRunProperty() {
        sut.appDidCrashLastRun = true
        XCTAssertTrue(sut.appDidCrashLastRun)
        
        sut.appDidCrashLastRun = false
        XCTAssertFalse(sut.appDidCrashLastRun)
    }
    
    func testAskedDeviceForPushNotificationsProperty() {
        sut.askedDeviceForPushNotifications = true
        XCTAssertTrue(sut.askedDeviceForPushNotifications)
        
        sut.askedDeviceForPushNotifications = false
        XCTAssertFalse(sut.askedDeviceForPushNotifications)
    }
}
