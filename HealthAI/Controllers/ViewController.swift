//
//  ViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 02/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func registerBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    
}

