//
//  Configuration.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/24/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit


/// All the configuration parameters are put up here
public struct Configuration {

    struct XMPPServer {
        static let host : String = "tools.innominds.com"
        static let port: UInt16 = 7070
        static let bindingUrl: String = "http://tools.innominds.com:7070/http-bind/"
        
        /// Test user credentials
        static let userName: String = "testin1@im.koderoot.net"
        static let userName2: String = "testin1@im.koderoot.net"
        static let pwd:String = "testin123"
        
    }
  
}
