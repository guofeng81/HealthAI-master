//
//  ViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 02/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
    }

    func setupLoginView(){
        registerBtn.layer.cornerRadius  = 4
        emailTextField.setPadding()
        emailTextField.underlined()
        passwordTextField.setPadding()
        passwordTextField.underlined()
        loginBtn.layer.cornerRadius = 25.0
        loginBtn.clipsToBounds = true
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
       
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0) {
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

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


