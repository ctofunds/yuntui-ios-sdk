//
//  DataManager.swift
//  yuntui-ios-sdk
//
//  Created by leo on 2018/1/18.
//  Copyright © 2018年 ltebean. All rights reserved.
//

import Foundation
import UIKit

public protocol PropertyValue {}

extension String: PropertyValue {}
extension Float: PropertyValue {}
extension Double: PropertyValue {}
extension Int: PropertyValue {}
extension Bool: PropertyValue {}

class User {
    var userId: Int = 0
    var appUserId: String = ""
    var pushId: String = ""
    var deviceId: String = ""
    var sysProperties: [String: Any] = [:]
    var userProperties: [String: Any] = [:]
    
    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "pushId": pushId,
            "deviceId": deviceId,
            "appUserId": appUserId,
            "sysProperties": sysProperties,
            "userProperties": userProperties
        ]
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.userId = dict["userId"] as! Int
        self.pushId = dict["pushId"] as! String
        self.deviceId = dict["deviceId"] as! String
        self.appUserId = dict["appUserId"] as! String
        self.sysProperties = dict["sysProperties"] as! [String: Any]
        self.userProperties = dict["userProperties"] as! [String: Any]
    }
}

class Event {
    var userId: Int = 0
    var sessionId: String = ""
    var eventName: String = ""
    var eventTime: String = ""
    var eventProperties: [String: Any] = [:]
    
    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "sessionId": sessionId,
            "eventName": eventName,
            "eventTime": eventTime,
            "eventProperties": eventProperties
        ]
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.userId = dict["userId"] as! Int
        self.sessionId = dict["sessionId"] as! String
        self.eventName = dict["eventName"] as! String
        self.eventTime = dict["eventTime"] as! String
        self.eventProperties = dict["eventProperties"] as! [String: Any]
    }
}


class DataManager {
    
    static let shared = DataManager()
    
    var appKey: String?

    var user = User()
    var events: [Event] = []
    
    func currentUser() -> User {
        return user
    }
    
    func save(user: User) {
        self.user = user
    }
    
    func save(events: [Event]) {
        self.events.append(contentsOf: events)
    }
    
    func popAllEvents() -> [Event] {
        let allEvents = events
        events = []
        return allEvents
    }
    
    
    
    func persistDataToFile() {
        guard let dataFileURL = getDataFileURL() else {
            return
        }
        let data: [String : Any] = [
            "user": user.toDict(),
            "events": events.map { $0.toDict() }
        ]
        NSDictionary(dictionary: data).write(to: dataFileURL, atomically: true)
    }
    
    func getDataFileURL() -> URL? {
        guard let appKey = appKey else {
            return nil
        }
        let fileName = "yuntui-\(String(appKey.reversed())).plist"
        print(fileName)
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)

    }
    
    func loadDataFromFile() {
        guard let dataFileURL = getDataFileURL() else {
            return
        }
        if let data = NSDictionary(contentsOf: dataFileURL) as? [String : Any] {
            // load user
            if let userDict = data["user"] as? [String: Any] {
                user = User(dict: userDict)
            } else {
                user = User()
            }
            // load events
            if let eventsArray = data["events"] as? [[String: Any]] {
                events = eventsArray.map { Event(dict: $0) }
            }
        } else {
            user = User()
        }
    }
    
}



