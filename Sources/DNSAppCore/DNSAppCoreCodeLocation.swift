//
//  DNSAppCoreCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCore
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias appCore = DNSAppCoreCodeLocation
}
open class DNSAppCoreCodeLocation: DNSCodeLocation {
    override open class var domainPreface: String { "com.doublenode.appCore." }
}
