//
//  ContactTableViewCell.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/17/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var contactNameAndSurnameLabel: UILabel!
    @IBOutlet weak var contactStatus: UILabel!
    
    var contactNameAndSurname = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contactPhoto.contentMode = .scaleAspectFill
        self.contactPhoto.layer.cornerRadius = 33
        self.contactPhoto.layer.masksToBounds = true
        // Initialization code
    }
    func updateContactCell(nameAndSurname: String, status: String, profileImage: String) {
        self.contactNameAndSurnameLabel.text = nameAndSurname
        self.contactStatus.text = status
        self.contactPhoto.loadImageUsingCacheWithUrlString(urlString: profileImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
