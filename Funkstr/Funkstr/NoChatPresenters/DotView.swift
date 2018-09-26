//
//  DotView.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/25/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit

@IBDesignable
class DotView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        print("rect ",rect)
//        self.layer.cornerRadius = rect.width/2.0
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }

}
