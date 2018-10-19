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
import Alamofire
import SwiftyJSON

class HealthMainViewController: UIViewController, CLLocationManagerDelegate{
    
//    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var weatherImage: UIImageView!
//    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "47aa6d0303fe5a8186915aa57b079446"
    
    let weatherDataModel = WeatherDataModel()

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if let user =  Auth.auth().currentUser {
            print(user.email ?? "No email address!")
            print(user.uid)
        }
        
    }
    //MARK - didUpdate the location methods which check the location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 1{
            locationManager.stopUpdatingLocation()
            print("logititude= \(location.coordinate.longitude)")
            
            
            let logititude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
            let params : [String:String] = ["lat":String(latitude), "lon":String(logititude),"appId": APP_ID]
            
            getWeatherData(url:WEATHER_URL,parameters: params)
            
            
        }
    }
    
    func getWeatherData(url:String,parameters:[String:String]){
        
        Alamofire.request(url,method:.get,parameters:parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("Success! Got the weather data")
                
                let weatherJSON :JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
                
            }else{
                print("Error, \(String(describing: response.result.error))")
            }
        }
        
    }
    
    func updateWeatherData(json:JSON){
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherCondition = json["weather"]["main"].stringValue
            
            updateUIWeatherData(weatherDataModel: weatherDataModel)
            
            print(weatherDataModel.temperature)
            print(weatherDataModel.city)
            print(weatherDataModel.weatherIconName)
            print(weatherDataModel.weatherCondition)
            
            
        }else{
            print("Weather Unavailable")
        }
        
    }
    
    //MARK - Update the Weather UI
    
    func updateUIWeatherData(weatherDataModel: WeatherDataModel){
    
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°C"
        weatherImage.image = UIImage(named: weatherDataModel.weatherIconName)
        conditionLabel.text = weatherDataModel.weatherCondition
        
    }
    
    //MARK - didFailWithError which tell when the location update is fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
}
