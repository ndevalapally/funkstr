//
//  LoginViewController.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    /// Password field
    @IBOutlet weak var pwdField: UITextField!
    
    /// User ID field
    @IBOutlet weak var idField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        #if DEBUG
        idField.text = "testin1"
        pwdField.text = "testin123"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Called when login button is tapped
    ///
    /// - Parameter sender: button
    @IBAction func loginTapped(_ sender: Any) {
        // Check the username and password for blank
        if let username = idField.text , let pwd = pwdField.text{
            
            if (username.isEmpty || pwd.isEmpty){
                // Alert both fields should be filled
                let alertController = UIAlertController(title: "Error", message: "Both username and password should be entered", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                let userIdFull = username // "test1" //username+"@"+Configuration.XMPPServer.host
                XMPPHandler.shared.startStream(userName: userIdFull, pwd: pwd)
                XMPPHandler.shared.onAuthenticate = {(error) -> Void in
                      self.performSegue(withIdentifier: "chatSegue", sender: nil)
                }
              
            }
        }
        
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

extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Next should be got")
        if(textField == idField){
            pwdField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
//    textfieldnext
}
