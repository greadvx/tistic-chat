//
//  ProfileViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/15/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        doRoundedTextFields(textField: nameTextField)
        doRoundedTextFields(textField: surnameTextField)
        doRoundedTextFields(textField: statusTextField)
        doRoundedButtons(button: saveButton)
    }
    func doRoundedTextFields(textField: UITextField) {
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        textField.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
    }
    func doRoundedButtons(button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0).cgColor
    }
}
