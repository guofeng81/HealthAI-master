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

class EditProfileViewController: UIViewController {

   
    var databaseRef : DatabaseReference!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
   
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()

        let userId = Auth.auth().currentUser?.uid

        databaseRef.child("profile").child(userId!).observeSingleEvent(of: .value, with:{ (snapshop) in
            let dictionary = snapshop.value as? NSDictionary

            //let username = dictionary?["username"] as? String ?? ""
            //self.usernameLabel.text = username


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

}
