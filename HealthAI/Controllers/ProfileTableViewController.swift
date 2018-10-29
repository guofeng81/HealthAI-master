//
//  ProfileTableViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/28/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class ProfileTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    let bioList = ["Height","Weight","Glucose","Blood Pressure"]
    
    var values = ["","","",""]
    
    var databaseRef : DatabaseReference!
    var storageRef : StorageReference!
    var LoginUser  = Auth.auth().currentUser!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getReferences()
        
    }
    
    internal func setProfilePicture(imageView: UIImageView){
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
    }
    
    func getReferences(){
        
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == 0 {
            numberOfRows =  1
        }else{
            numberOfRows =  4
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section == 0 {
                return "Profile"
            }else{
                return "BioCell"
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0  && indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
            
            
            setDatabaseUsername(user: LoginUser, label: cell.usernameLabel)
            
            //cell.usernameLabel.text = "Username"
            //setProfilePicture(imageView: cell.imageView!)
            //show the profile image from the database
            
            DatabaseHelper.loadDatabaseImage(databaseRef: databaseRef,user: LoginUser, imageView: cell.imageView!)
            
            //cell.imageView?.image = UIImage(named: "user")
            
            cell.editProfileBtn.addTarget(self, action: #selector(editProfileImage(imageView:)), for: .touchUpInside)
            
            return cell
            
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BioCell", for: indexPath) as! BioTableViewCell
            
            cell.bioLabel.text = bioList[indexPath.row]
            cell.numberLabel.text = values[indexPath.row]
            
            return cell
            
        }
    }
    
    func setDatabaseUsername(user: User, label:UILabel) {
        
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            let dictionary = snapshop.value as? NSDictionary
            DispatchQueue.main.async {
                label.text = dictionary?["username"] as? String
            }
        })
        
    }
    
    @objc func editProfileImage(imageView: UIImageView){
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: .actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: .default) { (action) in
            //let imageView = sender.view as! UIImageView
            
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            newImageView.backgroundColor = UIColor.white
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
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
    
    
    //MARK -  Update the Height for the row
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 0  && indexPath.section == 0{
            
            return 140.0
        }else{
            return 40        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let value = values[indexPath.row]

        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.updateAction(value: value, indePath: indexPath)
        }
        
        editAction.backgroundColor = UIColor.blue
        return [editAction]
        
    }
    
    private func updateAction(value: String,indePath: IndexPath){
        
        let alert = UIAlertController(title: "Update", message: "Update your Bio", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textField = alert.textFields?.first else{
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }else{
                    //let the label to be the textToEdit
                    self.values[indePath.row] = textToEdit
                    self.tableView.reloadRows(at: [indePath], with: .automatic)
                }
                
            }else{
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        guard let textField = alert.textFields?.first else{
            return
        }
        
        textField.placeholder = "Update your ..."
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert,animated: true)
        
    }
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        setProfilePicture(imageView: self.profileImageView)
//        
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            profileImageView.image = image
//        }
//        
//        savePictureToStorage(imageView: profileImageView)
//        
//        
//        
//        // Update the Navigation Drawer (Sidebar View) image
//        
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
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
