//
//  ContactsViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContactsViewController: UIViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        checkIfUserIsLoggedIn()
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: false)
        } else {
            fetchUser()
        }
            //my own name in database
//            let uid = Auth.auth().currentUser?.uid
    }
    @objc private func handleLogout() {
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User()
                user.name = dictionary["name"] as? String
                user.surname = dictionary["surname"] as? String
                user.email = dictionary["email"] as? String
                self.users.append(user)
            }
        }, withCancel: nil)
    }
}
