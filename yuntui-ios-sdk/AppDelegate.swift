//
//  AppDelegate.swift
//  yuntui-ios-sdk
//
//  Created by leo on 2018/1/17.
//  Copyright © 2018年 ltebean. All rights reserved.
//

import UIKit
import UserNotifications
import Yuntui

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        let appKey = "8eab6b7fdccb4792c1ebbc24"
        let channel = "Publish channel"
        let isProduction = true
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
        
        Yuntui.shared.setup(withAppKey: "test_app_key");
        JPUSHService.registrationIDCompletionHandler({ resCode, id in
            guard let id = id else { return }
            Yuntui.shared.setPushId(id)
        })
        Yuntui.shared.setAppUserId("123456")
        Yuntui.shared.setUserProperties([
            "gender": "male",
            "age": 21
        ])
        return true
    }

    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("get the deviceToken  \(deviceToken)")
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
}

extension AppDelegate: JPUSHRegisterDelegate {

    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        Yuntui.shared.handleNotificationUserInfo(userInfo)
        print("receive notification")
        
        print(userInfo)
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
    completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
}

