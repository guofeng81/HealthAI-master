//
//  AuthServices.swift
//  HealthAI
//
//  Created by Feng Guo on 10/15/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation
import FirebaseAuth


typealias Completion = (_ errMsg: String?,_ data: AnyObject?) -> Void

class AuthServices{
    
    private static let _instance = AuthServices()
    
    static var instance: AuthServices {
        return _instance
    }
    
    
    func login(email:String, password:String, onComplete: Completion?){
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }else{
                onComplete?(nil,result?.user)
                print("Successfully Log In!!")
            }
        }
    }
    
    
    func signup(email:String, password:String, onComplete:Completion?){
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }else{
                onComplete?(nil,result?.user)
                print("Successfully Sign up!!")
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?){
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .invalidEmail:
                onComplete?("The email address is invalid, please try the valid email address", nil)
                break
            case .weakPassword:
                onComplete?("The password is weak, please try some strong password.", nil)
                break
            case .credentialAlreadyInUse:
                onComplete?("The email address has already exist in the system, please use other email address to sign up.",nil)
                break
            case .sessionExpired:
                onComplete?("The seesion has been expired, please try again.",nil)
                break
            default:
                onComplete?("There is a problem authenticating, please try again.", nil)
            }
        }
        
    }
    
    
}


