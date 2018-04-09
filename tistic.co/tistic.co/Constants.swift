//
//  Constants.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/7/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import Foundation
import Firebase

struct Constants {
    struct refs{
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
