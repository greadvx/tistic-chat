//
//  MessageTableViewCell.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/29/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    //
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var lastMessagePrevLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePhoto.contentMode = .scaleAspectFill
        self.profilePhoto.layer.cornerRadius = 33
        self.profilePhoto.layer.masksToBounds = true
    }
    func updateMessageCell(nameAndSurname: String, lastMessagePrev: String, profilePhoto: String, timeStamp: NSNumber?) {
        self.nameAndSurnameLabel.text = nameAndSurname
        self.lastMessagePrevLabel.text = lastMessagePrev
        self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: profilePhoto)
        if let seconds = timeStamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
