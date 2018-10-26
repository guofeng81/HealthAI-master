//
//  DatabaseHelper.swift
//  HealthAI
//
//  Created by Feng Guo on 10/25/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase

class DatabaseHelper {
    
   
    private static let _instance = DatabaseHelper()
    
    static var instance: DatabaseHelper {
        return _instance
    }
    
    func loadDatabaseImage(databaseRef: DatabaseReference!, user: User) -> UIImage{
        
         //databaseRef = Database.database().reference()
        
        var image : UIImage?
        
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            let dictionary = snapshop.value as? NSDictionary
            
            //let username = dictionary?["username"] as? String ?? ""
            
            if let profileImageURL = dictionary?["photo"] as? String {
                
                let url = URL(string: profileImageURL)
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
//                    DispatchQueue.main.async {
                        //self.profileImageView.image = UIImage(data: data!)
                        image = UIImage(data: data!)
                    
                }).resume()
                
                //self.usernameLabel.text = username
                
            }
        }){
            (error) in
            print(error.localizedDescription)
            return
        }
        
        return image!
    }
    
    func getDatabaseUsername(databaseRef: DatabaseReference!, user: User) -> String {
        
        var username : String = ""
        
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            
            let dictionary = snapshop.value as? NSDictionary
            
            username = dictionary?["username"] as! String
        })
        
        return username
    }
    
}
