//
//  SignUpViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
    }
    @IBAction func createUser(_ sender: Any) {
        
        if (nameTextField.text!.isEmpty) {
            displayAlertMessage(messageToDisplay: "Please, input your name")
            return
        }
        if (surnameTextField.text!.isEmpty) {
            displayAlertMessage(messageToDisplay: "Please, input your surname")
            return
        }
        let emailIsInputed = RegularExpressions.isValidEmailAddress(emailAddressString: emailTextField.text!)
        if emailIsInputed == false {
            displayAlertMessage(messageToDisplay: "E-mail adress isn't correct.")
            return
        }
        if (passwordTextField.text! != confirmPasswordTextField.text!) {
            displayAlertMessage(messageToDisplay: "Passowrds not equal.")
            return
        } else {
            if (passwordTextField.text!.count == 0 && confirmPasswordTextField.text!.count == 0) {
                displayAlertMessage(messageToDisplay: "Empty fields password.")
                return
            }
            if (passwordTextField.text!.count < 6 && confirmPasswordTextField.text!.count <= 6) {
                displayAlertMessage(messageToDisplay: "Inputed password is too short. You need to input al least 6 characters.")
                return
            }
        }
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let surname = surnameTextField.text else {
            displayAlertMessage(messageToDisplay: "Registartion form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email,
                               password: password) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                //save user to database
                guard let uid = user?.uid else {
                    return
                }
                
                let reference = Database.database().reference(fromURL: "https://tistic-co.firebaseio.com/")
                let userReference = reference.child("users").child(uid)
                let userInfo = ["name" : name, "surname" : surname, "email" : email, "profileimageURL": "https://firebasestorage.googleapis.com/v0/b/tistic-co.appspot.com/o/profileImages%2FnotSet.png?alt=media&token=bdae4c55-432c-416c-9dd1-a6b83482fb2d", "status":"online"]
                userReference.updateChildValues(userInfo, withCompletionBlock: { (err, reference) in
                    if err != nil {
                        print("Error occured")
                        self.displayAlertMessage(messageToDisplay: (err?.localizedDescription)!)
                        return
                    } else {
                        
                    }
                })
                
            }
        }
        performSegue(withIdentifier: "submitSegue", sender: nil)
    }
    private func displayAlertMessage(messageToDisplay: String){
        
        let alertController = UIAlertController(title: "Error!", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func dismissSignUpVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
