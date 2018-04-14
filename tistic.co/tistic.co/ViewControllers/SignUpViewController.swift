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

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0)
        doRoundedTextFields(textField: nameTextField)
        doRoundedTextFields(textField: surnameTextField)
        doRoundedTextFields(textField: emailTextField)
        doRoundedTextFields(textField: passwordTextField)
        doRoundedTextFields(textField: confirmPasswordTextField)
        doRoundedButtons(button: submitButton)
        configurateView(view: subView)
    }
    
    func doRoundedTextFields(textField: UITextField) {
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        textField.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
    }
    func doRoundedButtons(button: UIButton) {
        button.layer.cornerRadius = 15.0
        submitButton.layer.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0).cgColor
    }
    func configurateView(view: UIView) {
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0)
    }
    
    
    
    
    
    
    @IBAction func createUser(_ sender: Any) {
        //pharse with regular expression
        //name
        //surname
        //email
        //password for equal 6 char
        //try catch block
//        let isValidEmail = isValidEmailAddress(emailAddressString: emailTextField.text!)
//        Auth.auth().createUser(withEmail: "qwert@gmail.com", password: "123456") { (user: User?, error: Error?) in
//            if error != nil {
//                print(error?.localizedDescription)
//                return
//        }
//            print(user)
//        }
    }
    
    
//    func isValidEmailAddress(emailAddressString: String) -> Bool {
//
//        var returnValue = true
//        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
//
//        do {
//            let regex = try NSRegularExpression(pattern: emailRegEx)
//            let nsString = emailAddressString as NSString
//            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
//
//            if results.count == 0 {
//                returnValue = false
//            }
//
//        } catch let error as NSError {
//            print("invalid regex: \(error.localizedDescription)")
//            returnValue = false
//        }
//
//        return  returnValue
//    }
    
//    func displayAlertMessage(messageToDisplay: String)
//    {
//        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
//
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//
//            // Code in this block will trigger when OK button tapped.
//            print("Ok button tapped");
//
//        }
//
//        alertController.addAction(OKAction)
//
//        self.present(alertController, animated: true, completion:nil)
//    }
    
    
    
    @IBAction func dismissSignUpVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
