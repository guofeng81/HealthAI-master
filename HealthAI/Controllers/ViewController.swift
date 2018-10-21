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
        performSegue(withIdentifier: "goToLogin", sender: self)
        
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

extension UIButton{
    
    func setupShadow(myBtn : UIButton){
        myBtn.layer.shadowColor = UIColor.black.cgColor
        myBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        myBtn.layer.masksToBounds = false
        myBtn.layer.shadowRadius = 1.0
        myBtn.layer.shadowOpacity = 0.5
        myBtn.layer.cornerRadius = myBtn.frame.width / 2
    }
}


