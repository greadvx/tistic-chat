//
//  extentionsProfileVC.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/27/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //gesture func that change photo (imageView)
    @objc func handleProfileImageView() {
         let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePhoto.image = selectedImage
            uploadImageViewToServer()
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func uploadImageViewToServer() {
        let imageName = NSUUID.init().uuidString
        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).jpg")
        if let profileImage = self.profilePhoto.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    if let currUsr = Auth.auth().currentUser?.uid {
                        DatabaseProvider.Instance.contactsReference.child(currUsr).updateChildValues(["profileImage" : profileImageUrl])
                    }
                    
                }
                
            })
        }
        
    }
}
