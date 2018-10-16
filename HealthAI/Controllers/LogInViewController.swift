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
            
            AuthServices.instance.login(email: email, password: password) { (errMsg, data) in
                guard errMsg == nil else {
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.performSegue(withIdentifier: "goToHealthMain", sender: self)
            }
            
         }else{
            
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    }
    
    
    func createAlert(controllertitle:String,message:String,actionTitle:String){
        let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both username and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
