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
    
//    let serverHost = "http://139.224.6.23:9004"
    let serverHost = "http://192.168.1.6:9004"
    let sdkVersion = "0.0.1"

    var appKey: String?
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func post(toPath path: String, body: Any, onSuccess: @escaping (_ data: Any) -> (), onError: @escaping (_ msg: String) -> ()) {
        guard let appKey = appKey else {
            return
        }
        var request = URLRequest(url: URL(string: "\(serverHost)\(path)")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.addValue(appKey, forHTTPHeaderField: "X-AppKey")
        request.addValue(sdkVersion, forHTTPHeaderField: "X-YutuiSDKVersion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                return onError("api error: network error")
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                return
            }
            guard let data = data else {
                return onError("api error: no data")
            }
            guard let json = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
                return onError("api error: json parse")
            }
            guard let code = json["code"] as? Int, code == 200 else {
                return onError("api error: code != 200")
            }
            return onSuccess(json["data"]!)
        })
        task.resume()
    }
}
