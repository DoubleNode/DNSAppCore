//
//  DNSAppGlobals.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCore
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCrashWorkers
import DNSCore
import DNSError
import DNSProtocols
import Foundation

public protocol DNSAppGlobalsProtocol {
    static var shared: DNSAppGlobals { get }
    static func checkAndAskForReview() -> Bool
}
open class DNSAppGlobals {
    public static var appLastDisplayedError: Error?
    public static var debugStartupString: String = ""
    public static var dynamicLinkUrlString: String = ""
    public static var shouldForceLogout: Bool = false
    public static var isRunningTest: Bool = false

    public var appDidCrashLastRun: Bool = false
    public var wkrAppReview: WKRPTCLAppReview = WKRCrashAppReviewWorker()

    public var askedDeviceForPushNotifications: Bool = false

    public class func appLastDisplayedErrorString() -> String {
        guard let error = appLastDisplayedError else {
            return "<NONE>"
        }
        guard let nsError = error as NSError? else {
            return "<NSErrorInvalid>"
        }
        let userInfo = nsError.userInfo
        var retval = error.localizedDescription
        retval += " [Timestamp: \(userInfo["DNSTimeStamp"] ?? "<NONE>")]"
        guard let localError = error as? LocalizedError else {
            return retval
        }
        retval += " {Failure: \(localError.failureReason ?? "<NONE>")}"
        return retval
    }
    required public init() {
        commonInit()
    }
    open func commonInit() {
        let launchedCount = 1 + (DNSCore.appSetting(for: C.AppGlobals.launchedCount,
                                                    withDefault: 0) as? UInt ?? 0)
        let launchedFirstTime = DNSCore.appSetting(for: C.AppGlobals.launchedFirstTime,
                                                   withDefault: Date()) as? Date ?? Date()
        let launchedLastTime = DNSCore.appSetting(for: C.AppGlobals.launchedLastTime,
                                                  withDefault: Date(timeIntervalSince1970: 0)) as? Date

        _ = DNSCore.appSetting(set: C.AppGlobals.launchedCount, with: launchedCount)
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedFirstTime, with: launchedFirstTime)
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedLastTime, with: launchedLastTime)
    }

    // MARK: - Application methods
    open func applicationDidBecomeActive() { }
    open func applicationWillResignActive() { }

    // MARK: - Review methods
    open func checkAndAskForReview() -> Bool {
        wkrAppReview.appDidCrashLastRun = appDidCrashLastRun
        wkrAppReview.launchedCount = DNSCore
            .appSetting(for: C.AppGlobals.launchedCount,
                        withDefault: 0) as! UInt
        wkrAppReview.launchedFirstTime = DNSCore
            .appSetting(for: C.AppGlobals.launchedFirstTime,
                        withDefault: Date()) as! Date
        wkrAppReview.launchedLastTime = DNSCore
            .appSetting(for: C.AppGlobals.launchedLastTime,
                        withDefault: Date(timeIntervalSince1970: 0)) as? Date
        wkrAppReview.reviewRequestLastTime = DNSCore
            .appSetting(for: C.AppGlobals.reviewRequestLastTime,
                        withDefault: Date(timeIntervalSince1970: 0)) as? Date

        let result = wkrAppReview.doReview()
        if case .failure = result {
            return false
        }
        _ = DNSCore.appSetting(set: C.AppGlobals.reviewRequestLastTime, with: Date())
        return true
    }
}
