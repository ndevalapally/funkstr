//
//  ChatMessage.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import RealmSwift
import NoChat

/// Defines a single Chat Message
class ChatMessage: Object,NOCChatItem {

    
     /// Unique message ID. generating random unique string everytime
    @objc dynamic var messageId:String = UUID().uuidString
    
    /// Message body
    @objc dynamic  var message:String = ""
    
     /// Date and time at which the message is received
    @objc dynamic  var receivedDate: Date?

     /// Is the message read?
    @objc dynamic  var isRead:Bool = false
    
    /// Message sent from
    @objc dynamic  var from:String = ""
    
    /// Message sent to 
    @objc dynamic  var to:String = ""
    
    
    /// Delivery status stored in the database
    @objc dynamic var deliverStatus: String = ""
    
    
    /// Date at which the message was delivered
    @objc dynamic  var date: Date = Date()
    
    var deliveryStatus:MessageDeliveryStatus{
        return .Delivered
    }
    
    
    @objc dynamic var isOutgoing: Bool = true

    
    override static func primaryKey()->String?{
    return "messageId"
    }
    
    
    /// Ignored properties not stored in database
    ///
    /// - Returns: array of ignored propertu names
    override static func ignoredProperties() -> [String] {
        return ["deliveryStatus"]
    }
    
    //MARK: NoChatItem compliance methods

    /// Unique Identifier of the message
    public func uniqueIdentifier() -> String {
        return self.messageId;
    }
    
    /// Type of message. Right now defaulted to text
    public func type() -> String {
        return "Text"
    }
    
    
}
