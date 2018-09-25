//
//  ChatsOverviewCell.swift
//  Funkstr
//
//  Created by Naresh Kumar Devalapally on 9/25/18.
//  Copyright © 2018 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit

class ChatsOverviewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusView: DotView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFor(user:ChatUser){
        userLabel.text = user.name
        messageLabel.text = user.status
        
    }

}
