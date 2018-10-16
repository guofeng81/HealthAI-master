//
//  RegisterViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/15/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0) {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                
                if error != nil {
                    
                    print("Error in creating new user, \(String(describing: error))")
                    
                }else{
                    
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
