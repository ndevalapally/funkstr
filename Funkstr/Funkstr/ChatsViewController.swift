//
//  ChatsViewController.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ChatsViewController: UIViewController {

    @IBOutlet weak var chatsTable: UITableView!
    
    var changeObserver:NotificationToken?
    
    var completeResults: Results<ChatUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let result = DBManager.shared.fetchFriends()
       changeObserver = result.observe { [weak self] (changes:RealmCollectionChange) in
            switch changes{
            case .initial(let initialValues):
                print("Initial,",initialValues)
                self?.completeResults = initialValues
                self?.chatsTable.reloadData()
            case .update(let changedValues, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.completeResults = changedValues
                self?.chatsTable.reloadData()
            case .error(let error):
                print("error")
            }
        }
        
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItems = [logoutBtn]
    
//        addAccounts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAccounts(){
        let names = ["testin1","testin2"]
        for singleName in names{
            XMPPHandler.shared.addUser(userName: singleName+"@"+Configuration.XMPPServer.host, nickName: singleName)
        }
    }
    
    @objc func logout(){
        XMPPHandler.shared.logoutUser(callback: {
            print("got the information")
            self.dismiss(animated: true, completion: nil)
            
        })
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

extension ChatsViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = self.completeResults else {
            return 0
        }
        return results.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatsOverviewCell
        if let results = self.completeResults{
            let currentUser = results[indexPath.row]
           cell.configureFor(user: currentUser)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let singleChatController = SingleChatViewController()
//        let dataSource = ChatDataSource(count: 20, pageSize: 50)
//        singleChatController.dataSource = dataSource
        let singleController = UserChatViewController()
        singleController.fromUser = completeResults?[indexPath.row]
        
        self.navigationController?.pushViewController(singleController, animated: true)
    }
}
