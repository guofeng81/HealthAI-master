//
//  ViewController.swift
//  HealthAI


import UIKit
import TKSubmitTransition

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
       
        
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector (loginViewTapped))
         loginView.addGestureRecognizer(tapGesture)
        
    }
    
    
    @objc func loginViewTapped() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
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
         self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    
    @IBAction func loginBtnPressed(_ sender: TKTransitionSubmitButton) {
       
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0) {
            AuthServices.instance.login(email: email, password: password) { (errMsg, data) in
                guard errMsg == nil else {
                    self.createAlert(controllertitle: "Error Authentication", message: errMsg!, actionTitle: "Ok")
                    sender.shake()
                    return
                }
                sender.animate(1, completion: {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: "goToHealthMain", sender: self)
                })
            }
        }else{
            createAlert(controllertitle: "Username and Password Required", message: "You must provide both username and password", actionTitle: "Ok")
            sender.shake()
        
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

extension UIButton {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}



