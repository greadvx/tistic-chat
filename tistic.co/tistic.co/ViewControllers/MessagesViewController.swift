//
//  MessagesViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MessagesViewController: UITableViewController {
    private let CELL_ID = "messageCell"
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        checkIfUserIsLoggedIn()
        observeMessages()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: false)
        }
    }
    @objc private func handleLogout() {
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
    }

    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message()
                message.text = dictionary["text"] as? String
                message.fromId = dictionary["fromId"] as? String
                message.toId = dictionary["toId"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)! 
                    })
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        
        }, withCancel: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let user = User()
                    user.name = dictionary["name"] as? String
                    user.surname = dictionary["surname"] as? String
                    user.profileImageURL = dictionary["profileImage"] as? String
                    user.status = dictionary["status"] as? String
                    cell.updateMessageCell(nameAndSurname: (user.name)! + " " + (user.surname)!, lastMessagePrev: message.text!, profilePhoto: (user.profileImageURL)!, timeStamp: message.timestamp!)
                }
                    
            }, withCancel: nil)
            
        }
        //fill here by messages and photo

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let y = 5
    }
}
