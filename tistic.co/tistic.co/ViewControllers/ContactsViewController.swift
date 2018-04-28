//
//  ContactsViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/11/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContactsViewController: UITableViewController, FetchData {

    @IBOutlet var myTableView: UITableView!
    private let CELL_ID = "contactCell"
    private let CHAT_SEGUE = "ChatSegue"
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        checkIfUserIsLoggedIn()
        DatabaseProvider.Instance.delegate = self
        DatabaseProvider.Instance.getContacts()
    }
    
    func dataReceived(contacts: [User]) {
        self.users = contacts
        myTableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //here indexPath is used to navigate in snapshot of information of users
        let cell: ContactTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ContactTableViewCell
        cell.updateContactCell(nameAndSurname: users[indexPath.row].name! + " " + users[indexPath.row].surname!, status: users[indexPath.row].status!, profileImage: users[indexPath.row].profileImageURL!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: here I need to send data
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil)
    }
}
