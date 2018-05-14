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
        messages.removeAll()
        messagesDictionary.removeAll()
        observeUserMessages()
        myTableView.allowsMultipleSelectionDuringEditing = true
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
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageReference = Database.database().reference().child("messages").child(messageId)
                messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: Any] {
                        let message = Message()
                        message.text = dictionary["text"] as? String
                        message.fromId = dictionary["fromId"] as? String
                        message.toId = dictionary["toId"] as? String
                        message.timestamp = dictionary["timestamp"] as? NSNumber
                        
                        if let  chatPartnerId = message.chatPartnerId() {
                            self.messagesDictionary[chatPartnerId] = message
                        }
                        self.attemptReloadTable()
                    }
                }, withCancel: nil)
            }, withCancel: nil)
            
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
            
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
            
        }, withCancel: nil)
    }
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    var timer: Timer?
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                if error != nil {
                    print ("Failed to delete: ", error!)
                    return
                }
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadTable()

//                self.messages.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
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
      
        if let id = message.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let user = User()
                    user.uid = snapshot.key
                    user.name = dictionary["name"] as? String
                    user.surname = dictionary["surname"] as? String
                    user.profileImageURL = dictionary["profileImage"] as? String
                    user.status = dictionary["status"] as? String
                    if message.text == nil {
                        message.text = "Media item"
                    }
                    cell.updateMessageCell(nameAndSurname: (user.name)! + " " + (user.surname)!, lastMessagePrev: message.text!, profilePhoto: (user.profileImageURL)!, timeStamp: message.timestamp!)
                }
                    
            }, withCancel: nil)
            
        }
        //fill here by messages and photo

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboardMessages = UIStoryboard(name: "Messages", bundle: nil)
        let chat = storyboardMessages.instantiateViewController(withIdentifier: "ActiveChat") as! ActiveChatViewController
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            let user = User()
            user.uid = snapshot.key
            user.name = dictionary["name"] as? String
            user.surname = dictionary["surname"] as? String
            user.profileImageURL = dictionary["profileImage"] as? String
            user.status = dictionary["status"] as? String
            user.email = dictionary["email"] as? String
            chat.outgoingUser = user 
            let chatViewController = UINavigationController(rootViewController: chat)
            self.show(chatViewController, sender: nil)
        }, withCancel: nil)
        
    }
}
