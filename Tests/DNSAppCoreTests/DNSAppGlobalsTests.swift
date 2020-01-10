//
//  DNSAppGlobalsTests.m
//  DoubleNode Core - DNSAppCore
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
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
