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
    
    static func loadDatabaseImage(databaseRef: DatabaseReference!, user: User, imageView: UIImageView){
        
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
                    DispatchQueue.main.async {
                        //self.profileImageView.image = UIImage(data: data!)
                        imageView.image = UIImage(data: data!)
                    }
                    
                }).resume()
                
                //self.usernameLabel.text = username
                
            }
        }){
            (error) in
            print(error.localizedDescription)
            return
        }
        
    }
    
    static func setDatabaseUsername(databaseRef: DatabaseReference!, user: User, label: UILabel){
        
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            
            let dictionary = snapshop.value as? NSDictionary
            
            label.text = dictionary?["username"] as? String
        })
    }
    
    static func setBioValues(databaseRef: DatabaseReference!, user: User, values: [String]){
        
        //let values = ["height":"","weight":"","glucose": "","bloodpressure":""]
        
//        databaseRef.child("profile").child(user.uid).setValue(values) { (error, ref) in
//                if error != nil {
//                    print(error!)
//                    return
//                }else{
//                    print("Profile successfully created!")
//                }
//            }
        
        databaseRef.child("profile").child(user.uid).setValue(["height": values[0]])
        databaseRef.child("profile").child(user.uid).setValue(["weight": values[1]])
        databaseRef.child("profile").child(user.uid).setValue(["glucose": values[2]])
        databaseRef.child("profile").child(user.uid).setValue(["bloodpressue": values[3]])
        
    
    }
    
    static func loadBioVlaues(databaseRef: DatabaseReference!, user: User) -> [String]{
        
        var values = ["","","",""]
        
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            
            let dictionary = snapshop.value as? NSDictionary
            
            values[0] = dictionary!["height"] as! String
            values[1] = dictionary!["weight"] as! String
            values[2] = dictionary!["glucose"] as! String
            values[3] = dictionary!["bloodpressure"] as! String
            
        })
        
        return values
        
    }
    
    
    
}
