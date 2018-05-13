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

class SettingsViewController: UITableViewController, GetUser {
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func resetPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: usernameLabel.text!) { error in
            if error != nil {
                print(error!)
            }
            self.displayAlertMessage(messageToDisplay: "Link to modify your password was sent to \(self.usernameLabel.text!)")
        }
    }
    @IBAction func logOut(_ sender: Any) {
        self.updateStatusOfUser()
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Start", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "initScreen") as UIViewController
        present(initialViewControlleripad, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        DatabaseProvider.Instance.delegateGet = self
        DatabaseProvider.Instance.getCurrentUserInfo()
        self.profilePhoto.contentMode = .scaleAspectFill
        self.profilePhoto.layer.cornerRadius = 55
        self.profilePhoto.layer.masksToBounds = true
    }
    func setValuesOfUser(current user: User) {
        self.nameAndSurnameLabel.text = user.name! + " " + user.surname!
        self.usernameLabel.text = user.email!
        self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: user.profileImageURL!)
        self.statusLabel.text = user.status!
    }
    private func displayAlertMessage(messageToDisplay: String){
        
        let alertController = UIAlertController(title: "Attention!", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.updateStatusOfUser()
            self.dismiss(animated: true, completion: nil)
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Start", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "initScreen") as UIViewController
            self.present(initialViewControlleripad, animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
    }
    private func updateStatusOfUser() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid)
            ref.updateChildValues(["status":"offline"]) { (error, reference) in
                if error != nil {
                    print(error!)
                    return
                }
            }
        }
    }
    func userInfoReceived(current user: User) {
        self.setValuesOfUser(current: user)
        self.tableView.reloadData()
    }
}
