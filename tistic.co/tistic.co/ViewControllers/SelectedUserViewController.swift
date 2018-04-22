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
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendMessageButton(_ sender: Any) {
        
        //TODO: HERE SNEDER IS A DATA TO SEND TO ANOTHER SCREEN
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveMessages")
        
        //here I will send data to the view
        
        self.present(viewController, animated: true, completion: nil)
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        doRoundedButtons(button: sendMessageButton)
    }
    func doRoundedButtons(button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.backgroundColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0).cgColor
    }
    
    
}
