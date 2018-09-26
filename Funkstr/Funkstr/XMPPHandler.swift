//
//  XMPPHandler.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import XMPPFramework

/// Singleton class to handle all the XMPP Communication
class XMPPHandler: NSObject, XMPPStreamDelegate,XMPPRosterDelegate {
    
    
    /// Singleton object
    static let shared = XMPPHandler()
    
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster?
    let xmppStream = XMPPStream()
    
    var currentUserName: String?
    var currentPassword: String?
    
    // Events delegation
    var onAuthenticate:((_ error:Error?)->())?
    
    var logoutCallback: (()->())?
    
    
    private override init() {
        xmppStream.hostName = Configuration.XMPPServer.host
        xmppStream.hostPort = Configuration.XMPPServer.port
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        super.init()
        xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
    
    }
    
    
    /// Called to add a user into the stream
    ///
    /// - Parameters:
    ///   - userName: name of the user
    ///   - nickName: Nick Name to be put up
    func addUser(userName:String,nickName:String){
        if let userObj = XMPPJID(string: userName){
            xmppRoster?.addUser(userObj, withNickname: nickName)
        }
        
    }
    
    /// Starts the stream with connected username and password
    ///
    /// - Parameters:
    ///   - userName: username
    ///   - pwd: password
    func startStream(userName:String, pwd:String){
        currentUserName = userName
        currentPassword = pwd
        
        xmppStream.myJID = XMPPJID(string: currentUserName!)
     
        if xmppStream.isDisconnected{
            try!   xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
        }
    }
    
    
    /// Send message to a user
    ///
    /// - Parameters:
    ///   - userName: username of the user
    ///   - message: Message text to be sent
    func sendMessage(userName:String, message:String){
        
        let senderJID = XMPPJID(string: userName) //XMPPJID.jidWithString(userName)
        let msg = XMPPMessage(type: "chat", to: senderJID)
        msg.addBody(message)
        msg.addOriginId("1234")
        xmppStream.send(msg)
    }
    
    
    /// Disconnect from stream
    func logoutUser(callback:@escaping ()->()){
        if(xmppStream.isConnected){
        xmppStream.disconnect()
            logoutCallback = callback
        }
    }
    
    //MARK: XMPPStreamDelegate Methods
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("Stream connected")
        try! sender.authenticate(withPassword: self.currentPassword!)
        
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
        print("Stream disconnected")
        logoutCallback?()
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("Authenticated")
        //var xmppRoster: XMPPRoster
        xmppRoster?.activate(xmppStream)
        xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
        let presense = XMPPPresence() // XMPPPresence(type: "probe")
        xmppStream.send(presense)
        xmppRoster?.fetch()
        
        self.onAuthenticate?(nil)
        
    }
  
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        print("Received presence in Roster")
        print(presence)
        if  let presenceType = presence.type{
            if presenceType == "subscribe"{
                xmppRoster?.subscribePresence(toUser: presence.from!)
                xmppRoster?.acceptPresenceSubscriptionRequest(from: presence.from!, andAddToRoster: true)
                // Probably a friend request
            }
            else {
//                    xmppRoster?.subscribePresence(toUser: presence.from!)
                let theUser = ChatUser()
                theUser.jabberId = (presence.from?.bare)!
                theUser.status = presence.type!
                theUser.name = (presence.from?.user)!
                print(presence.from?.user)
                print(presence.type)
                print(presence.delayedDeliveryDate)
//                presence.ch
//                print(presence.)
                print(presence.showValue)
                DBManager.shared.add(object: theUser)
            }
        }
    }
    
    func xmppStream(_ sender: XMPPStream, didSend iq: XMPPIQ) {
        print("Sent message IQ")
        
    }
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        
        return true
    }
    
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("Did send message")
        print(message)
        let newChatMessage  = ChatMessage()
        newChatMessage.from = self.currentUserName!
        newChatMessage.to = (message.to?.bare)!
        newChatMessage.message = message.body!
        DBManager.shared.add(object: newChatMessage)
    }
    func xmppStream(_ sender: XMPPStream, didFailToSend message: XMPPMessage, error: Error) {
        print("Failed to send message")
    }
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        print("received message Stream")
        print(message)
        let newChatMessage  = ChatMessage()
        newChatMessage.from = (message.from?.bare)!
        newChatMessage.to = self.currentUserName!
        newChatMessage.message = message.body!
        newChatMessage.isOutgoing = false
        DBManager.shared.add(object: newChatMessage)
    }
    
    
    //MARK: XMPPRosterDelegate Methods
    
    func xmppRosterDidBeginPopulating(_ sender: XMPPRoster, withVersion version: String) {
        print("Roster started populating")
    }
    
    func xmppRoster(_ sender: XMPPRoster, didReceiveRosterItem item: DDXMLElement) {
        if let userName = item.attribute(forName: "jid")?.stringValue{
            let theUser = ChatUser()
            theUser.jabberId = userName
            theUser.name = item.attribute(forName: "name")?.stringValue ?? ""
            DBManager.shared.updateUser(userId: userName, newData: theUser)
        }
       
    }
    
    func xmppRoster(_ sender: XMPPRoster, didReceiveRosterPush iq: XMPPIQ) {
        print("roster received push ROSTER")
    }
    func xmppRosterDidEndPopulating(_ sender: XMPPRoster) {
        print("Finished populating")
    }
    
   
    
}
