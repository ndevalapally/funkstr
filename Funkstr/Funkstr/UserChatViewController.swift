//
//  UserChatViewController.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/25/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import NoChat
import Realm
import RealmSwift

class UserChatViewController: NOCChatViewController ,TGChatInputTextPanelDelegate{

    var layoutQueue = DispatchQueue(label: "com.innominds.funkstr.userchatqueue", qos: DispatchQoS(qosClass: .default, relativePriority: 0))
    
    var changeObserver:NotificationToken?
    
    var completeResults: Results<ChatMessage>?
    
    var titleView = TGTitleView()
//    var avatarButton = TGAvatarButton()
    
    var fromUser: ChatUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        avatarButton.setImage(#imageLiteral(resourceName: "outgoing"), for: .normal)
        titleView.title = fromUser?.name
        
        
        self.navigationItem.titleView = titleView
        
//        let spacerItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacerItem.width = -12
//
//        let rightItem = UIBarButtonItem(customView: avatarButton)
//
//        navigationItem.rightBarButtonItems = [spacerItem, rightItem]

        // Do any additional setup after loading the view.
        
        completeResults = DBManager.shared.getChats(from: fromUser!.jabberId)
        changeObserver = completeResults?.observe { [weak self] (changes) in
            switch changes{
            case .initial(let collection):
                print("Initial")
                let coll = Array(collection).map({ChatMessage(value: $0)})
                print("Messages",coll.count)
                self?.addMessages(coll, scrollToBottom: true, animated: true)
            case .update(let final, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("Changes")
                let additions = insertions.map({final[$0]})
                 self?.addMessages(additions, scrollToBottom: true, animated: true)
//                let modifiedObjects = modifications.map({final[$0]})
                
                // update the UI for modified ones
            case .error(let err):
                print("error")
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: NoChat library methods
    
    override class func cellLayoutClass(forItemType type: String) -> Swift.AnyClass? {
        if type == "Text" {
            return TGTextMessageCellLayout.self
        } else if type == "Date" {
            return TGDateMessageCellLayout.self
        } else if type == "System" {
            return TGSystemMessageCellLayout.self
        } else {
            return nil
        }
    }
    
    override class func inputPanelClass() -> Swift.AnyClass? {
        return TGChatInputTextPanel.self
    }
    
    override func registerChatItemCells() {
        collectionView?.register(TGTextMessageCell.self, forCellWithReuseIdentifier: TGTextMessageCell.reuseIdentifier())
        collectionView?.register(TGDateMessageCell.self, forCellWithReuseIdentifier: TGDateMessageCell.reuseIdentifier())
        collectionView?.register(TGSystemMessageCell.self, forCellWithReuseIdentifier: TGSystemMessageCell.reuseIdentifier())
    }
    

    private func addMessages(_ messages: [ChatMessage], scrollToBottom: Bool, animated: Bool) {
        layoutQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let indexes = IndexSet(integersIn: 0..<messages.count)
            
            var layouts = [NOCChatItemCellLayout]()
            
            for message in messages {
                let layout = strongSelf.createLayout(with: message)!
                layouts.insert(layout, at: 0)
            }
            
            DispatchQueue.main.async {
                strongSelf.insertLayouts(layouts, at: indexes, animated: animated)
                if scrollToBottom {
                    strongSelf.scrollToBottom(animated: animated)
                }
            }
        }
    }
    
    func inputTextPanel(_ inputTextPanel: TGChatInputTextPanel, requestSendText text: String) {
        
        print("stuff happens")
//        let msg = ChatMessage()
//        msg.message = text
//        addMessages([msg], scrollToBottom: true, animated: true)
        if let theUser  = self.fromUser {
            XMPPHandler.shared.sendMessage(userName: theUser.jabberId, message: text)
        }
//        XMPPHandler.shared.sendMessage(userName: "testin2@"+Configuration.XMPPServer.host, message: text)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
