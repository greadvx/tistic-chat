//
//  Message.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/29/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageMediaURL: String?
    var videoMediaURL: String?
    
    override init() {
        self.fromId = "none"
        self.text = "none"
        self.timestamp = 1
        self.toId = "none"
    }
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
