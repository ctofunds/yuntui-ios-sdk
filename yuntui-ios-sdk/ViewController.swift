//
//  ViewController.swift
//  yuntui-ios-sdk
//
//  Created by leo on 2018/1/17.
//  Copyright © 2018年 ltebean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func addToCart(_ sender: Any) {
        Yuntui.shared.logEvent(name: "add_to_cart", properties: [
            "category": "game",
            "price": 100
        ])
    }
    
    @IBAction func checkout(_ sender: Any) {
        Yuntui.shared.logEvent(name: "order", properties: [
            "price": 1000,
            "category": "game"
        ])
    }
    
}

