//
//  DNSAppCoreCodeLocationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCoreTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSAppCore
import DNSError

class DNSAppCoreCodeLocationTests: XCTestCase {
    
    func testDomainPreface() {
        let expectedPreface = "com.doublenode.appCore."
        XCTAssertEqual(DNSAppCoreCodeLocation.domainPreface, expectedPreface)
    }
    
    func testCodeLocationInheritance() {
        let location = DNSAppCoreCodeLocation("code_location_test")
        XCTAssertTrue(location is DNSCodeLocation)
        XCTAssertTrue(location is DNSAppCoreCodeLocation)
    }
    
    func testSendableConformance() {
        let location = DNSAppCoreCodeLocation("code_location_test")
        XCTAssertNotNil(location)
        
        // Test that it can be used in concurrent contexts (Sendable conformance)
        Task {
            let _ = DNSAppCoreCodeLocation.domainPreface
        }
    }
    
    func testTypeAlias() {
        // Test that the type alias works correctly
        let _ = DNSCodeLocation.appCore.self
        XCTAssertTrue(DNSCodeLocation.appCore.self == DNSAppCoreCodeLocation.self)
    }
    
    func testDomainPrefaceConsistency() {
        let location1 = DNSAppCoreCodeLocation("consistency_test_1")
        let location2 = DNSAppCoreCodeLocation("consistency_test_2")
        
        XCTAssertEqual(type(of: location1).domainPreface, type(of: location2).domainPreface)
    }
    
    func testDomainPrefaceFormat() {
        let domainPreface = DNSAppCoreCodeLocation.domainPreface
        
        // Test that it follows the expected format
        XCTAssertTrue(domainPreface.hasPrefix("com.doublenode."))
        XCTAssertTrue(domainPreface.hasSuffix("."))
        XCTAssertTrue(domainPreface.contains("appCore"))
    }
}