//
//  SignUpViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func createUser(_ sender: Any) {
        //pharse with regular expression
        //name
        //surname
        //email
        //password for equal 6 char
        //try catch block
        Auth.auth().createUser(withEmail: "qwert@gmail.com", password: "123456") { (user: User?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription)
                return
        }
            print(user)
        }
    }
    
    @IBAction func dismissSignUpVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
