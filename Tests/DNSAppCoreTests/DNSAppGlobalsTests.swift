//
//  DNSAppGlobalsTests.m
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
        sut = nil
        super.tearDown()
    }

    func test_zero() {
        XCTFail("Tests not yet implemented in DNSAppGlobalsTests")
    }
}
