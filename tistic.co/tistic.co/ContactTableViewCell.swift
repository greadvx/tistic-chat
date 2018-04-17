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
        // Initialization code
    }
    func updateContactCell(nameAndSurname: String, status: String) {
        self.contactNameAndSurnameLabel.text = nameAndSurname
        self.contactStatus.text = status
        //self.contactPhoto = photo
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
