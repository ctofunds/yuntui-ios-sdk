//
//  Network.swift
//  yuntui-ios-sdk
//
//  Created by leo on 2018/1/17.
//  Copyright © 2018年 ltebean. All rights reserved.
//

import Foundation

class Network {
    
    static let shared = Network()
    
    let serverHost = "http://47.100.43.25:9004"
//    let serverHost = "http://192.168.1.16:9004"

    var appKey: String?
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func post(toPath path: String, body: Any, onSuccess: @escaping (_ data: Any) -> (), onError: @escaping () -> ()) {
        guard let appKey = appKey else {
            return
        }
        var request = URLRequest(url: URL(string: "\(serverHost)\(path)")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.addValue(appKey, forHTTPHeaderField: "X-AppKey")
        request.addValue("1.0.0", forHTTPHeaderField: "X-YutuiSDKVersion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                return onError()
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                return
            }
            guard let data = data else {
                return onError()
            }
            guard let json = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
                return onError()
            }
            let code = json["code"] as! Int
            guard code == 200 else {
                return onError()
            }
            return onSuccess(json["data"]!)
        })
        task.resume()
    }
}
