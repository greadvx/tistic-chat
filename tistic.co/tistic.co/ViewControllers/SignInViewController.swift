//
//  SignInViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInWithFacebook: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var separativeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0)
        doRoundedTextFields(textField: emailTextField)
        doRoundedTextFields(textField: passwordTextField)
        doRoundedButtons(button: signInButton)
        signInButton.layer.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0).cgColor
        doRoundedButtons(button: signInWithFacebook)
        signInWithFacebook.layer.backgroundColor = UIColor(red:0.24, green:0.32, blue:0.58, alpha:1.0).cgColor
        configurateView(view: separativeView)
    }
    func doRoundedTextFields(textField: UITextField) {
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        textField.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
    }
    func doRoundedButtons(button: UIButton) {
        button.layer.cornerRadius = 15.0
    }
    func configurateView(view: UIView) {
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0)
    }
    @IBAction func signIn(_ sender: Any) {
        let emailIsInputed = RegularExpressions.isValidEmailAddress(emailAddressString: emailTextField.text!)
        if passwordTextField.text!.isEmpty && passwordTextField.text!.count < 6 {
            displayAlertMessage(messageToDisplay: "Please, input password. Minimal length is 6 charcters.")
            return
        }
        if emailIsInputed != true {
            displayAlertMessage(messageToDisplay: "E-mail adress is incorrect. Please input correct e-mail adress.")
            return
        }
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay:error!.localizedDescription)
                return
            } else {
                self.performSegue(withIdentifier: "signIn", sender: nil)
            }
        }
    }
    
    private func displayAlertMessage(messageToDisplay: String){
        
        let alertController = UIAlertController(title: "Error!", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
}
