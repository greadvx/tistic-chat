//
//  DatabaseProvider.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/17/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage


protocol FetchData: class {
    func dataReceived(contacts: [User])
}
protocol GetUser: class {
    func userInfoReceived(current user: User)
}

class DatabaseProvider {
    
    weak var delegate: FetchData?
    weak var delegateGet: GetUser?
    
    private static let _instance = DatabaseProvider()
    
    private init() {}
    
    static var Instance: DatabaseProvider {
        return _instance
    }
    
    var databaseReference : DatabaseReference {
        return Database.database().reference()
    }
    
    var storageReference : StorageReference {
        return Storage.storage().reference(forURL: "gs://tistic-co.appspot.com")
    }
    
    var contactsReference : DatabaseReference {
        return databaseReference.child(Constants.USERS)
    }
    var messagesReference : DatabaseReference {
        return databaseReference.child(Constants.MESSAGES)
    }
    var mediaMessagesReference: DatabaseReference {
       return databaseReference.child(Constants.MEDIA_MESSAGES)
    }
    var imageStorageReference: StorageReference {
        return storageReference.child(Constants.IMAGE_STORAGE)
    }
    var videoStorgaeReference: StorageReference {
        return storageReference.child(Constants.VIDEO_STORAGE)
    }
    
    func saveUser(with name: String, surname: String, email: String, status: String){
     ////////////
    }
    
    func getContacts() {
        contactsReference.observe(.value, with: { (snapshot) in
            var contacts = [User]()
            if let myContacts = snapshot.value as? NSDictionary {
                for (key, value) in myContacts {
                    if let contactData = value as? NSDictionary {
                        let user = User()
                        user.uid = key as? String
                        user.email = contactData[Constants.EMAIL] as? String
                        user.name = contactData[Constants.NAME] as? String
                        user.surname = contactData[Constants.SURNAME] as? String
                        user.status = contactData[Constants.STATUS] as? String
                        user.profileImageURL = contactData[Constants.PHOTOURL] as? String
                        contacts.append(user)
                    }
                }
            
            }
            self.delegate?.dataReceived(contacts: contacts)
        }, withCancel: nil)
        
    }
    func getCurrentUserInfo() {
        if let currentUserID = Auth.auth().currentUser?.uid {
            contactsReference.child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                let currentUser = User()
                let value = snapshot.value as? NSDictionary
                currentUser.email = value?["email"] as? String ?? ""
                currentUser.name = value?["name"] as? String ?? ""
                currentUser.surname = value?["surname"] as? String ?? ""
                currentUser.status = value?["status"] as? String ?? ""
                currentUser.profileImageURL = value?["profileImage"] as? String ?? ""
             self.delegateGet?.userInfoReceived(current: currentUser)
            }, withCancel: nil)
            
        }
    }
}


