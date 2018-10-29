//
//  ProfileViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/29/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet var usernameLabel: UILabel!
    
    var databaseRef : DatabaseReference!
    var storageRef : StorageReference!
    var LoginUser  = Auth.auth().currentUser!
    var imagePicker = UIImagePickerController()
    
    
    let bioList = ["Height","Weight","Glucose","Blood Pressure"]
    
    let unitList = ["cm","lb","mm","mm"]
    
    let values = ["150","150","150","150"]
    
    //MARK - Table View Set up
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath) as! BioCell
        
        cell.textLabel?.text = bioList[indexPath.row]
        
        // cell.bioLabel.text = bioList[indexPath.row]
        cell.unitLabel.text = unitList[indexPath.row]
        cell.valueLabel.text = values[indexPath.row]
        
        return cell
    }
    
    
    //MARK - Set up the Profile UIViewController
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getReferences()
        setProfilePicture(imageView: profileImageView)
        
        DatabaseHelper.loadDatabaseImage(databaseRef: databaseRef,user: LoginUser, imageView: profileImageView)
        DatabaseHelper.setDatabaseUsername(databaseRef: databaseRef, user: LoginUser, label: usernameLabel)
        
    }
    
    
    func getReferences(){
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
    }
    
    internal func setProfilePicture(imageView: UIImageView){
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
    }
    
    
    @IBAction func editProfileImage(_ sender: UIButton) {
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: .actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: .default) { (action) in
            
            let newImageView = UIImageView(image: self.profileImageView.image)
            
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
    
    
    @IBAction func saveProfileBtn(_ sender: UIButton) {
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func dismissFullScreenImage(sender : UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    //MARK -  Pick the image from the photo library
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        setProfilePicture(imageView: self.profileImageView)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        savePictureToStorage(imageView: profileImageView)
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: nil)
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePictureToStorage(imageView: UIImageView){
        
        if let imageData: Data = imageView.image!.pngData() {
            
            let profilePicReference = storageRef.child("user_profile/\(LoginUser.uid)/profile_pic")
            
            DispatchQueue.main.async {
                profilePicReference.putData(imageData, metadata: nil) { (metadata, error) in
                    if error == nil {
                        print("Successfuly putting the data to the storage.")
                        
                        profilePicReference.downloadURL { (url, error) in
                            if let downloadUrl = url {
                                
                                print(downloadUrl)
                                self.databaseRef.child("profile").child(self.LoginUser.uid).child("photo").setValue(downloadUrl.absoluteString)
                                
                            }else {
                                print("error downloading the url!")
                            }
                        }
                        
                    }else {
                        print("error putting the data into the storage.")
                    }
                }
            }
        }
    }
    

}
