//
//  HealthMainViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/15/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class HealthMainViewController: UIViewController, CLLocationManagerDelegate{
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        if let user =  Auth.auth().currentUser {
            print(user.email ?? "No email address!")
            print(user.uid)
        }
        
        
        
    }

}
