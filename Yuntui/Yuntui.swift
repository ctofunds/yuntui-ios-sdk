//
//  Yuntui.swift
//  yuntui-ios-sdk
//
//  Created by leo on 2018/1/17.
//  Copyright © 2018年 ltebean. All rights reserved.
//

import Foundation
import UIKit

public class Yuntui {
    
    public static let shared = Yuntui()
    
    private let network = Network.shared
    private let dataManager = DataManager.shared
    
    private var sessionId = UUID().uuidString
    
    private var pushPayload: [String: Any]?
    
    
    public func setup(withAppKey appKey: String) {
        network.appKey = appKey
        // load data
        dataManager.loadDataFromFile()
        // update user properties
        
        dataManager.currentUser().sysProperties = [
            "platform": "ios",
            "osVersion": UIDevice.current.systemVersion,
            "bundleId": Bundle.main.bundleIdentifier!,
            "appVersion": Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,
            "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        // check user id
        if dataManager.currentUser().userId == 0 {
            createUser()
        }
        // regsiter notification
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        // log app open event
        logEvent(name: "@open_app", properties: [:])
    }
    
    public func handleNotificationUserInfo(_ userInfo: [AnyHashable : Any]) {
        pushPayload = userInfo["@yuntui"] as? [String: Any]
        // update exsiting events in this session
        if let pushPayload = pushPayload {
            dataManager.events.forEach({ event in
                if event.sessionId == sessionId {
                    event.eventProperties.merge(pushPayload, uniquingKeysWith: { (first, _) in first })
                }
            })
        }
    }
    
    public func setPushId(_ pushId: String) {
        dataManager.currentUser().pushId = pushId
        updateUser()
    }
    
    public func setAppUserId(_ appUserId: String) {
        dataManager.currentUser().appUserId = appUserId
    }
    
    public func setUserProperties(_ properties: [String: PropertyValue]) {
        dataManager.currentUser().userProperties = properties
    }

    
    public func logEvent(name: String, properties: [String: PropertyValue]) {
        let event = Event()
        event.eventName = name
        event.eventProperties = [:]
        event.eventProperties.merge(properties, uniquingKeysWith: { (first, _) in first })
        if let pushPayload = pushPayload {
            event.eventProperties.merge(pushPayload, uniquingKeysWith: { (first, _) in first })
        }
        event.sessionId = sessionId
        event.userId = dataManager.currentUser().userId
        event.eventTime = currentTime()
        dataManager.save(events: [event])
        
        if dataManager.events.count >= 50 {
            pushEvents()
        }
    }
    
    private func createUser() {
        let user = dataManager.currentUser()
        guard user.userId == 0 else {
            return
        }
        network.post(toPath: "/api/v1/user/create", body: user.toDict(), onSuccess: { data in
            guard let userId = data as? Int else {
                return
            }
            self.dataManager.currentUser().userId = userId
            self.dataManager.events.forEach { $0.userId = userId }
        }, onError: {
            
        })
    }
    
    private func updateUser() {
        let user = dataManager.currentUser()
        guard user.userId != 0 else {
            return
        }
        network.post(toPath: "/api/v1/user/update", body: user.toDict(), onSuccess: { data in

        }, onError: {
            
        })
    }
    
    private func pushEvents() {
        let user = dataManager.currentUser()
        guard user.userId != 0 else {
            return
        }
        let events = dataManager.popAllEvents()
        guard events.count > 0 else {
            return
        }
        let body = events.map({ $0.toDict() })
        network.post(toPath: "/api/v1/event/create", body: body, onSuccess: { data in
            
        }, onError: {
            
        })
    }
    
    private func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Yuntui {
    
    @objc func applicationWillEnterForeground() {
        sessionId = UUID().uuidString
        logEvent(name: "@open_app", properties: [:])
    }
    
    @objc func applicationDidEnterBackground() {
        logEvent(name: "@close_app", properties: [:])
        updateUser()
        pushEvents()
        dataManager.persistDataToFile()
        pushPayload = nil
    }
}


