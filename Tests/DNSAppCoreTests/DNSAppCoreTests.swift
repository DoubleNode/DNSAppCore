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
    func testModuleImport() {
        XCTAssertTrue(true, "DNSAppCore module should import successfully")
    }

    static let allTests = [
        ("testModuleImport", testModuleImport),
    ]
}
