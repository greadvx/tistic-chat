//
//  ActiveChatViewController.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/15/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseAuth
import FirebaseDatabase

class ActiveChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var messages = [JSQMessage]()
    let picker = UIImagePickerController()
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var outgoingUser: User? {
        didSet {
            observeMessages()
        }
    }
    var currentUserID: String?
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                let message = Message()
                message.fromId = dictionary["fromId"] as? String
                message.toId = dictionary["toId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
//                if message.imageURL = dictionary["imageURL"] as? String {
//                    //construct media message
//                } else {
                if message.chatPartnerId() == self.outgoingUser?.uid {
                    let validMessage = JSQMessage(senderId: message.fromId!, senderDisplayName: message.fromId!, date: Date(timeIntervalSince1970: TimeInterval(truncating: message.timestamp!)), text: message.text!)
                    self.messages.append(validMessage!)
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
               // }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0).cgColor
        picker.delegate = self
        currentUserID = Auth.auth().currentUser?.uid
        self.senderId = currentUserID
        self.senderDisplayName = "sender"
        self.title = String((outgoingUser?.name)! + " " + (outgoingUser?.surname)!)
        //turn off my image in chatlog
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    ////////////here logic for sender receiver
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if let profileImageURL = self.outgoingUser?.profileImageURL {
            cell.avatarImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
            cell.avatarImageView.layer.cornerRadius = 13
            cell.avatarImageView.layer.masksToBounds = true
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
//        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        handleSend(fromId: currentUserID!, toId: (outgoingUser?.uid!)!, message: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == currentUserID {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0))
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.lightGray)
        }
    }
    //photo of users
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
            return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "Contacts_disactive"), diameter: 30)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Choose a media", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default, handler: {
            (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        })
        let videos = UIAlertAction(title: "Videos", style: .default, handler: {
            (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie)
        })
        alert.addAction(photos)
        alert.addAction(videos)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let img = JSQPhotoMediaItem(image: pic)
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: img))
        } else {
            if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
                let video = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
                messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
            }
        }
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item]
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true, completion: nil)

            }
        }
    }
    func handleSend(fromId: String, toId: String, message: String) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": message, "toId": toId, "fromId": fromId, "timestamp":timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
}
