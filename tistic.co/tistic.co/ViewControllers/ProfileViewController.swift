//
//  ProfileViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/15/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, GetUser {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveUpdatedData(_ sender: Any) {
        self.pushNewDataToDatabase()
    }
    
    private var userInfo = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        doRoundedTextFields(textField: nameTextField)
        doRoundedTextFields(textField: surnameTextField)
        doRoundedTextFields(textField: statusTextField)
        doRoundedButtons(button: saveButton)
        profilePhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView)))
        profilePhoto.isUserInteractionEnabled = true
        DatabaseProvider.Instance.delegateGet = self
        DatabaseProvider.Instance.getCurrentUserInfo()
    }
    func doRoundedTextFields(textField: UITextField) {
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        textField.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0)
    }
    func doRoundedButtons(button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0).cgColor
    }
    func userInfoReceived(current user: User) {
        self.userInfo = user
        self.nameTextField.text = userInfo.name
        self.surnameTextField.text = userInfo.surname
        self.statusTextField.text = userInfo.status
        self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: userInfo.profileImageURL!)
        self.profilePhoto.contentMode = .scaleAspectFill
        self.profilePhoto.layer.cornerRadius = 50
        self.profilePhoto.layer.masksToBounds = true
        
    }
    func pushNewDataToDatabase() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(currentUserId)
            let dictionary = ["name": nameTextField.text!, "surname":surnameTextField.text!, "statusCustom": statusTextField.text!, "status": statusTextField.text!]
            ref.updateChildValues(dictionary) { (error, reference) in
                if error != nil {
                    print(error!)
                }
            }
        }
    }
   
}
