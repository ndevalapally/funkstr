//
//  ViewController.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit

import XMPPFramework

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        prepareStream()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareStream() {
        
        XMPPHandler.shared.startStream(userName: Configuration.XMPPServer.userName, pwd: Configuration.XMPPServer.pwd)
     
    }
    
    @IBAction func addUserTapped(_ sender: Any) {
        
    }
    
}


