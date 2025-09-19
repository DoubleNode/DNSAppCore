//
//  DNSAppCoreTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCoreTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest

@testable import DNSAppCore

final class DNSAppCoreTests: XCTestCase {

    // MARK: - Basic Object Creation Tests

    func test_dnsAppGlobals_canBeCreated() {
        let globals = DNSAppGlobals()
        XCTAssertNotNil(globals)
    }

    func test_dnsAppConfigurator_canBeCreated() {
        let configurator = DNSAppConfigurator()
        XCTAssertNotNil(configurator)
    }

    func test_dnsAppCoreCodeLocation_canBeCreated() {
        let codeLocation = DNSAppCoreCodeLocation(DNSAppCoreCodeLocation.self, #file, #line, #function)
        XCTAssertNotNil(codeLocation)
    }

    // MARK: - Basic Property Tests

    func test_dnsAppGlobals_staticProperties() {
        // Test static properties without external dependencies
        let originalDebugString = DNSAppGlobals.debugStartupString
        DNSAppGlobals.debugStartupString = "test"
        XCTAssertEqual(DNSAppGlobals.debugStartupString, "test")
        DNSAppGlobals.debugStartupString = originalDebugString
    }

    func test_dnsAppGlobals_instanceProperties() {
        let globals = DNSAppGlobals()

        // Test instance properties without external calls
        let originalCrashValue = globals.appDidCrashLastRun
        globals.appDidCrashLastRun = true
        XCTAssertTrue(globals.appDidCrashLastRun)
        globals.appDidCrashLastRun = originalCrashValue
    }

    func test_dnsAppConfigurator_basicFunctionality() {
        let configurator = DNSAppConfigurator()

        // Test basic array operations without complex dependencies
        XCTAssertNotNil(configurator.systems)
        XCTAssertNotNil(configurator.workers)
        XCTAssertEqual(configurator.systems.count, 0)
        XCTAssertEqual(configurator.workers.count, 0)
    }

    static var allTests = [
        ("test_dnsAppGlobals_canBeCreated", test_dnsAppGlobals_canBeCreated),
        ("test_dnsAppConfigurator_canBeCreated", test_dnsAppConfigurator_canBeCreated),
        ("test_dnsAppCoreCodeLocation_canBeCreated", test_dnsAppCoreCodeLocation_canBeCreated),
        ("test_dnsAppGlobals_staticProperties", test_dnsAppGlobals_staticProperties),
        ("test_dnsAppGlobals_instanceProperties", test_dnsAppGlobals_instanceProperties),
        ("test_dnsAppConfigurator_basicFunctionality", test_dnsAppConfigurator_basicFunctionality),
    ]
}