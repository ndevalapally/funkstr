//
//  XMPPHandler.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import XMPPFramework
import DCXMPP

/// Singleton class to handle all the XMPP Communication
class XMPPHandler: NSObject, XMPPStreamDelegate,XMPPRosterDelegate {
    
    
    /// Singleton object
    static let shared = XMPPHandler()
    
    //let xmppRosterStorage = XMPPRosterCoreDataStorage()
    //var xmppRoster: XMPPRoster?
   // let xmppStream = XMPPStream()
    let boschStream: DCXMPP = DCXMPP.manager()

    var currentUserName: String?
    var currentPassword: String?
    
    // Events delegation
    var onAuthenticate:((_ error:Error?)->())?
    
    var logoutCallback: (()->())?
    
    
    private override init() {
//        xmppStream.hostName = Configuration.XMPPServer.host
//        xmppStream.hostPort = Configuration.XMPPServer.port
//        xmppStream.bin
//        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)

        super.init()
//        xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        boschStream.delegate = self
    }
    
    
    /// Called to add a user into the stream
    ///
    /// - Parameters:
    ///   - userName: name of the user
    ///   - nickName: Nick Name to be put up
    func addUser(userName:String,nickName:String){
        if let userObj = XMPPJID(string: userName){
//            xmppRoster?.addUser(userObj, withNickname: nickName)
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
        boschStream.connect(userName, password: pwd, host: Configuration.XMPPServer.host, boshURL: Configuration.XMPPServer.bindingUrl)
//        boschStream.connect(userName, rid: <#T##Int64#>, sid: <#T##String!#>, host: <#T##String!#>, boshURL: <#T##String!#>)
//        xmppStream.myJID = XMPPJID(string: currentUserName!)

//        if xmppStream.isDisconnected{
//            try!   xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
//        }
    }
    
    
    /// Send message to a user
    ///
    /// - Parameters:
    ///   - userName: username of the user
    ///   - message: Message text to be sent
    func sendMessage(userName:String, message:String){
        
        // Create the new chat message with status Delivering
        let newChatMessage  = ChatMessage()
        newChatMessage.from = self.currentUserName!
        newChatMessage.to =  userName
        newChatMessage.deliverStatus = "Delivering"
        newChatMessage.message = message
        // Insert or update in realm
        DBManager.shared.add(object: newChatMessage)
        
        // Send the message
        let senderJID = XMPPJID(string: userName) //XMPPJID.jidWithString(userName)
        let msg = XMPPMessage(type: "chat", to: senderJID)
        msg.addBody(message)
        // Put up a unique ID for the chat message with the same Unique ID.
        msg.addOriginId(newChatMessage.messageId)
//        xmppStream.send(msg)

        
       
    }
    
    
    /// Disconnect from stream
    func logoutUser(callback:@escaping ()->()){
//        if(xmppStream.isConnected){
//        xmppStream.disconnect()
//            logoutCallback = callback
//        }
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
//        xmppRoster?.activate(xmppStream)
//        xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
//        let presense = XMPPPresence() // XMPPPresence(type: "probe")
//        xmppStream.send(presense)
//        xmppRoster?.fetch()

        self.onAuthenticate?(nil)
        
    }
  
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        print("Received presence in Roster")
        print(presence)
        if  let presenceType = presence.type{
            if presenceType == "subscribe"{
//                xmppRoster?.subscribePresence(toUser: presence.from!)
//                xmppRoster?.acceptPresenceSubscriptionRequest(from: presence.from!, andAddToRoster: true)
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
        
        // Dont execute if there is no originId
        guard let originId = message.originId else {return}
        // Just change the status of the same message.
  
        if let existingMessage = DBManager.shared.fetchMessage(with: originId){
            // Make an unmanaged object out of existing one
            let unmanagedObject = ChatMessage(value:existingMessage)
            unmanagedObject.deliverStatus = "Delivered"
            DBManager.shared.add(object: unmanagedObject)
            
        }
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

extension XMPPHandler: DCXMPPDelegate {
    func didReceiveBookmarks() {
        print("Received bookmarks")
    }

    func didReceiveMessage(_ message: String!, from user: DCXMPPUser!, attributes: [AnyHashable : Any]! = [:]) {
        print("Did receive message")
    }

    func didReceiveGroupMessage(_ message: String!, group: DCXMPPGroup!, from user: DCXMPPUser!, attributes: [AnyHashable : Any]! = [:]) {
        print("did receive group message")
    }

    func didReceiveGroupCarbon(_ message: String!, group: DCXMPPGroup!, from user: DCXMPPUser!, attributes: [AnyHashable : Any]! = [:]) {
        print("did receive group carbon")
    }

    func didReceive(_ state: DCTypingState, from user: DCXMPPUser!) {
        print("Did receive typing state")
    }

    func didReceiveGroupTypingState(_ state: DCTypingState, group: DCXMPPGroup!, from user: DCXMPPUser!) {
        print("Did receive group typing state")
    }

    func userDidJoin(_ group: DCXMPPGroup!, user: DCXMPPUser!) {
        print("user did join")
    }

    func userDidLeave(_ group: DCXMPPGroup!, user: DCXMPPUser!) {
        print("user did leave")
    }

    func didUpdateVCard(_ user: DCXMPPUser!) {
        print("User did update vCard")
    }

    func didUpdatePresence(_ user: DCXMPPUser!) {
        print(#function)
    }

    func didReceiveBuddyRequest(_ user: DCXMPPUser!) {
        print(#function)
    }

    func buddyDidAccept(_ user: DCXMPPUser!) {
        print(#function)
    }

    func buddyDidRemove(_ user: DCXMPPUser!) {
        print(#function)
    }

    func didReceiveGroupInvite(_ group: DCXMPPGroup!, from user: DCXMPPUser!) {
        print(#function)
    }


    func didXMPPConnect() {
        print(#function)
    }

    func didFailXMPPLogin() {
        print(#function)
    }

    func didReceiveRoster(_ users: [Any]!) {
        print(#function)
    }
}
