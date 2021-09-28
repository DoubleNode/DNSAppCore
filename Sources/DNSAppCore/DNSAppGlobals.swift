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
    public static var appLastDisplayedError: DNSError?

    public var appDidCrashLastRun: Bool = false
    public var appReviewWorker: PTCLAppReview = WKRCrashAppReviewWorker()

    public var askedDeviceForPushNotifications: Bool = false

    public class func appLastDisplayedErrorString() -> String {
        guard let dnsError = appLastDisplayedError else {
            return "<NONE>"
        }
        guard let nsError = dnsError as NSError? else {
            return "<NSErrorInvalid>"
        }
        let userInfo = nsError.userInfo
        var retval = dnsError.errorDescription ?? ""
        retval += " [Timestamp: \(userInfo["DNSTimeStamp"] ?? "<NONE>")]"
        retval += " {Failure: \(dnsError.failureReason ?? "<NONE>")}"
        return retval
    }
    required public init() {
        commonInit()
    }
    open func commonInit() {
        let launchedCount       = 1 + (DNSCore.appSetting(for: C.AppGlobals.launchedCount,
                                                          withDefault: 0) as? UInt ?? 0)
        let launchedFirstTime   = DNSCore.appSetting(for: C.AppGlobals.launchedFirstTime,
                                                     withDefault: Date()) as? Date ?? Date()
        let launchedLastTime    = DNSCore.appSetting(for: C.AppGlobals.launchedLastTime,
                                                     withDefault: Date(timeIntervalSince1970: 0)) as? Date

        _ = DNSCore.appSetting(set: C.AppGlobals.launchedCount, with: launchedCount)
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedFirstTime, with: launchedFirstTime)
        _ = DNSCore.appSetting(set: C.AppGlobals.launchedLastTime, with: launchedLastTime)
    }

    // MARK: - Application methods

    open func applicationDidBecomeActive() {
    }
    open func applicationWillResignActive() {
    }

    // MARK: - Review methods

    open func checkAndAskForReview() -> Bool {
        appReviewWorker.appDidCrashLastRun = appDidCrashLastRun
        appReviewWorker.launchedCount = DNSCore
            .appSetting(for: C.AppGlobals.launchedCount,
                        withDefault: 0) as! UInt
        appReviewWorker.launchedFirstTime = DNSCore
            .appSetting(for: C.AppGlobals.launchedFirstTime,
                        withDefault: Date()) as! Date
        appReviewWorker.launchedLastTime = DNSCore
            .appSetting(for: C.AppGlobals.launchedLastTime,
                        withDefault: Date(timeIntervalSince1970: 0)) as? Date
        appReviewWorker.reviewRequestLastTime = DNSCore
            .appSetting(for: C.AppGlobals.reviewRequestLastTime,
                        withDefault: Date(timeIntervalSince1970: 0)) as? Date

        var reviewed = false
        do {
            reviewed = try appReviewWorker.doReview()
            if reviewed {
                _ = DNSCore.appSetting(set: C.AppGlobals.reviewRequestLastTime, with: Date())
            }
        } catch {
        }
        return reviewed
    }
}
