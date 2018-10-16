//
//  RegisterViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/15/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0) {
            
            AuthServices.instance.signup(email: email, password: password) { (errMsg, data) in
                guard errMsg == nil else {
                    SVProgressHUD.dismiss()
                    self.createAlert(controllertitle: "Error Authentication", message: errMsg!, actionTitle: "Ok")
                    return
                }
                self.performSegue(withIdentifier: "goToHealthMain", sender: self)
                SVProgressHUD.dismiss()
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
