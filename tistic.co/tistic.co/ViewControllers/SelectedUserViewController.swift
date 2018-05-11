//
//  SelectedUserViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/15/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit

class SelectedUserViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBAction func sendMessageButton(_ sender: Any) {
        let storyboardMessages = UIStoryboard(name: "Messages", bundle: nil)
        
        let chat = storyboardMessages.instantiateViewController(withIdentifier: "ActiveChat") as! ActiveChatViewController
        chat.outgoingUser = user
        let chatViewController = UINavigationController(rootViewController: chat)
        show(chatViewController, sender: nil)
    }
    //current user info
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        doRoundedButtons(button: sendMessageButton)
        setupDataOfUser()
        profilePhoto.contentMode = .scaleAspectFill
        profilePhoto.layer.cornerRadius = 50
        profilePhoto.layer.masksToBounds = true
    }
    func doRoundedButtons(button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0).cgColor
    }
    func doRoundedPhoto(photo: UIImageView) {
        photo.layer.cornerRadius = 33
    }
    func setupDataOfUser() {
        nameLabel.text! = (user?.name)!
        surnameLabel.text! = (user?.surname)!
        statusLabel.text! = (user?.status)!
        profilePhoto.loadImageUsingCacheWithUrlString(urlString: (user?.profileImageURL)!)
        
    }
  
}
