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
                    self.createAlert(controllertitle: "Error Authentication", message: errMsg!, actionTitle: "Ok")
                    return
                }
                 self.performSegue(withIdentifier: "goToHealthMain", sender: self)
                
            }
        }else{
            createAlert(controllertitle: "Username and Password Required", message: "You must provide both username and password", actionTitle: "Ok")
        }
    }
    
    func createAlert(controllertitle: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: controllertitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
   
}
