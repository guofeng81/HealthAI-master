//
//  LogInViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/15/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
         if let email = emailText.text, let password = passwordText.text, (email.count > 0 && password.count > 0) {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (auth
                , error) in
                if error != nil {
                    
                    print("User failed Log In!!,\(String(describing: error))")
                }else{
                    
                    print("User Successfully Log In")
                    self.performSegue(withIdentifier: "goToHealthMain", sender: self)
                }
            }
            
         }else{
            
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    }
    
    
    
    
}
