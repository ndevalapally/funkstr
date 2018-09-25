//
//  ChatUser.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import RealmSwift

class ChatUser: Object {
    
    @objc dynamic var name:String = ""
    // JID for the user
    @objc dynamic var jabberId:String = ""
    @objc dynamic var userId:String = ""
    @objc dynamic var status:String = ""
    
    override static func primaryKey()->String?{
        return "jabberId"
    }
}
