//
//  EditProfileViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/23/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

   
    var databaseRef : DatabaseReference!
    var storageRef : StorageReference!
    var LoginUser  = Auth.auth().currentUser!
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
   
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()

        let userId = Auth.auth().currentUser?.uid

        databaseRef.child("profile").child(userId!).observeSingleEvent(of: .value, with:{ (snapshop) in
            let dictionary = snapshop.value as? NSDictionary

            let username = dictionary?["username"] as? String ?? ""
           
            if let profileImageURL = dictionary?["photo"] as? String {

                let url = URL(string: profileImageURL)

                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data!)
                    }
                }).resume()
                
                 self.usernameLabel.text = username
                
            }
        }){
            (error) in
            print(error.localizedDescription)
            return
        }
        
    }
    
    @IBAction func saveProfileBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfileBtn(_ sender: Any) {
        
    }
    
    
    internal func setProfilePicture(imageView: UIImageView){
        
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.white as! CGColor
        imageView.layer.masksToBounds = true
        //imageView.image = imageToSet
    }
    
    
    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: .actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: .default) { (action) in
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            
            newImageView.backgroundColor = UIColor.white
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            let tap = UIGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage(sender:)))
            newImageView.addGestureRecognizer(tap)
            
            self.view.addSubview(newImageView)
            
            
        }
        
        let photoGallery = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    @objc func dismissFullScreenImage(sender : UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        setProfilePicture(imageView: self.profileImageView)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        if let imageData: Data = self.profileImageView.image!.pngData() {
            
            let profilePicReference = storageRef.child("user_profile/\(LoginUser.uid)/profile_pic")
            
            let uploadTask = profilePicReference.putData(imageData, metadata: nil) { (metadata, error) in
                if error == nil {
                    let downloadUrl = self.storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                        }else{
                            //self.databaseRef.child("profile").child(LoginUser.uid).child("photo").setValue(downloadUrl)
                        }
                    })
                    
                    
                    
                    
                }
            }
            
            
            
            
        }
        
    }
    

    

    
    
    
    
    
    
    
    
    
    

}
