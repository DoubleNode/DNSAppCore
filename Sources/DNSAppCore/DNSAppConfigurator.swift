//
//  DNSAppConfigurator.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCore
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSBlankSystems
import DNSBlankWorkers
import DNSCore
import DNSProtocols
import Foundation

public protocol DNSAppConfiguratorProtocol {
    // MARK: - UIWindowSceneDelegate methods

    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    func didBecomeActive()

    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    func willResignActive()

    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    func willEnterForeground()

    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    func didEnterBackground()
}

open class DNSAppConfigurator: DNSAppConfiguratorProtocol {
    public var systems: [PTCLBase_SystemProtocol] = []
    public var workers: [PTCLBase_Protocol] = []

    public required init() { }
    
    // MARK: - UIWindowSceneDelegate methods

    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    open func didBecomeActive() {
        systems.forEach { (system) in
            system.didBecomeActive()
        }
        workers.forEach { (worker) in
            worker.didBecomeActive()
        }
    }

    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    open func willResignActive() {
        systems.forEach { (system) in
            system.willResignActive()
        }
        workers.forEach { (worker) in
            worker.willResignActive()
        }
    }

    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    open func willEnterForeground() {
        systems.forEach { (system) in
            system.willEnterForeground()
        }
        workers.forEach { (worker) in
            worker.willEnterForeground()
        }
    }

    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    open func didEnterBackground() {
        systems.forEach { (system) in
            system.didEnterBackground()
        }
        workers.forEach { (worker) in
            worker.didEnterBackground()
        }
    }
}
