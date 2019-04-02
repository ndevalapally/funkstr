//
//  DBManager.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import  RealmSwift

/// Singleton class to handle changes in the database
class DBManager: NSObject {
    
    
    /// Shared instance of the DBManager
    static let shared: DBManager = DBManager()

    
    private override init() {
        
    }
    
    /// Internal realm object
    let realmObject: Realm  =  {
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 4) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                    
                }
        })
        return try! Realm(configuration: config)
    }()
    
    
    func add<T:Object>(object:T) {
        try! realmObject.write {
            realmObject.add(object, update: true)
        }
    }
    
    func updateUser(userId:String,newData:ChatUser){
        if let user = realmObject.object(ofType: ChatUser.self, forPrimaryKey: userId){
            try! realmObject.write {
                if(!newData.name.isEmpty){
                user.name = newData.name
                }
            }
        }
    }
    
    
    /// Fetches a single message based on ID
    ///
    /// - Parameter messageId: messageId unique to the message
    /// - Returns: ChatMessage Optional object
    func fetchMessage(with messageId:String)->ChatMessage?{
        
       return realmObject.object(ofType: ChatMessage.self, forPrimaryKey: messageId)
    }
    
    
    /// Fetches the chats between current user and the other user
    ///
    /// - Parameter user: userId of the other user
    func getChats(from user:String)->Results<ChatMessage>?{
        if  let currentUser = XMPPHandler.shared.currentUserName{
       let result =  realmObject.objects(ChatMessage.self).filter("to = %@ AND from = %@ OR to = %@ AND from = %@",currentUser,user,user,currentUser )
            return result
            
        }
        else{
            return nil
        }
    }
    
    func fetch<T:Object>(type: T.Type)->Results<T>{
        let result = realmObject.objects(type)
        return result
    }
    
    
    func fetchFriends()->Results<ChatUser>{
        let result = realmObject.objects(ChatUser.self).filter("jabberId != %@", XMPPHandler.shared.currentUserName!)
        return result
    }
    
    

}
