//
//  DNSAppGlobalsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCoreTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest

@testable import DNSAppCore

class DNSAppGlobalsTests: XCTestCase {
    private var sut: DNSAppGlobals!

    override func setUp() {
        super.setUp()
        sut = DNSAppGlobals()
    }

    override func tearDown() {
        // Clean up static properties
        DNSAppGlobals.appLastDisplayedError = nil
        DNSAppGlobals.debugStartupString = ""
        DNSAppGlobals.dynamicLinkUrlString = ""
        DNSAppGlobals.shouldForceLogout = false
        DNSAppGlobals.isRunningTest = false

        sut = nil
        super.tearDown()
    }

    // MARK: - Static Properties Tests

    func test_appLastDisplayedError_defaultValue() {
        XCTAssertNil(DNSAppGlobals.appLastDisplayedError)
    }

    func test_debugStartupString_defaultValue() {
        XCTAssertEqual(DNSAppGlobals.debugStartupString, "")
    }

    func test_debugStartupString_canBeSet() {
        DNSAppGlobals.debugStartupString = "Debug startup info"
        XCTAssertEqual(DNSAppGlobals.debugStartupString, "Debug startup info")
    }

    func test_shouldForceLogout_defaultValue() {
        XCTAssertFalse(DNSAppGlobals.shouldForceLogout)
    }

    func test_shouldForceLogout_canBeSet() {
        DNSAppGlobals.shouldForceLogout = true
        XCTAssertTrue(DNSAppGlobals.shouldForceLogout)
    }

    // MARK: - Instance Properties Tests

    func test_appDidCrashLastRun_defaultValue() {
        XCTAssertFalse(sut.appDidCrashLastRun)
    }

    func test_appDidCrashLastRun_canBeSet() {
        sut.appDidCrashLastRun = true
        XCTAssertTrue(sut.appDidCrashLastRun)
    }

    func test_askedDeviceForPushNotifications_defaultValue() {
        XCTAssertFalse(sut.askedDeviceForPushNotifications)
    }

    func test_askedDeviceForPushNotifications_canBeSet() {
        sut.askedDeviceForPushNotifications = true
        XCTAssertTrue(sut.askedDeviceForPushNotifications)
    }

    func test_wkrAppReview_hasDefaultValue() {
        XCTAssertNotNil(sut.wkrAppReview)
    }

    // MARK: - Basic Functionality Tests

    func test_init_completesSuccessfully() {
        let globals = DNSAppGlobals()
        XCTAssertNotNil(globals)
        XCTAssertNotNil(globals.wkrAppReview)
    }

    func test_applicationDidBecomeActive_doesNotThrow() {
        XCTAssertNoThrow(sut.applicationDidBecomeActive())
    }

    func test_applicationWillResignActive_doesNotThrow() {
        XCTAssertNoThrow(sut.applicationWillResignActive())
    }
}