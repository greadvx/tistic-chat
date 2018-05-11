//
//  SettingsViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UITableViewController {
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        loadDataOfCurrentUser()
        self.profilePhoto.contentMode = .scaleAspectFill
        self.profilePhoto.layer.cornerRadius = 55
        self.profilePhoto.layer.masksToBounds = true
    }
    func loadDataOfCurrentUser(){
        //searching in base user and constructing in here
        
        if let currentUserId = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(currentUserId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    let user = User()
                     user.email = dictionary["email"] as? String
                    user.name = dictionary["name"] as? String
                    user.surname = dictionary["surname"] as? String
                    user.profileImageURL = dictionary["profileImage"] as? String
                    user.status = dictionary["status"] as? String
                    self.setValuesOfUser(current: user)
                DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }, withCancel: nil)
            
        }
    }
    func setValuesOfUser(current user: User) {
        self.nameAndSurnameLabel.text = user.name! + " " + user.surname!
        self.usernameLabel.text = user.email!
        self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: user.profileImageURL!)
        self.statusLabel.text = user.status!
    }
    
}
