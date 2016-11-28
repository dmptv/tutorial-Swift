//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Dima Tixon on 21/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

import UIKit
import CoreLocation


// "http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=3aeb0927332507b5d1c47e8cccb8c7b9"

class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humodotyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var openWeather = OpenWeatherMap() // сделали экзэмпляр класса OpenWeatherMap (владелец протокола)
    var hud = MBProgressHUD()
    let locationManager: CLLocationManager = CLLocationManager()
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background
        let imageName = "1bg.jpg"
        let bg = UIImage(named: imageName)
        self.view.backgroundColor = UIColor(patternImage: bg!)

        // Set setup
        self.openWeather.delagete = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func displayCity()  {
        let alert = UIAlertController(title: "City",
                                      message: "enter name City",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: "cancel",
                                   style: UIAlertActionStyle.cancel,
                                   handler: nil)
        
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action)->Void in
            
            if let textField = (alert.textFields?.first) as UITextField! {
                self.activityIndicator()
                self.openWeather.weatherFor(city: textField.text!) // загрузка данных
            }
            
        }
        
        alert.addAction(ok)
        
        alert.addTextField { (textFiled)->Void in // добавили тексфилд в алерт
            textFiled.placeholder = "City Name"
        }
        
        self.present(alert, animated: true, completion: nil) // презентуем алерт контролер
    }
    
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        hud.backgroundColor = UIColor.gray
        hud.alpha = 0.6
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    
    //Mark: OpenWeatherMapDelegate
    
         // required метод для делегата
    func updateWeatherInfo(weatherJson: JSON) {
        hud.hide(animated: true)
        
        if let tempResult = weatherJson["main"]["temp"].double {
            
            // Get country
            let country = weatherJson["sys"]["country"].stringValue
            
            // Get city name
            let cityName = weatherJson["name"].stringValue
            self.cityNameLabel.text = "\(cityName), \(country)"
            
            // Get time
            let time = weatherJson["dt"].intValue
            let timeToStr = openWeather.timeFromUnix(unixTime: time)
            self.timeLabel.text = "At \(timeToStr) it is"
            
            // Get convert temperature
            let temperature = openWeather.convertTemperature(contry: country, temperature: tempResult)
            self.tempLabel.text = "\(temperature)"
            
            // get icon
            let weather = weatherJson["weather"][0]
            let condition = weather["id"].intValue
            let nightTime = openWeather.isTimeNight(weaatherJson: weatherJson)
            let icon = openWeather.updateWeatherIcon(condition: condition, nightTime: nightTime)
            
            // Get description
            let descr = weather["description"].stringValue
            self.descriptionLabel.text = descr
            
            // Get speed wind
            let speed = weatherJson["wind"]["speed"].doubleValue
            self.speedWindLabel.text = "\(speed)"
            
            // Get humididty
            let humidity = weatherJson["main"]["humidity"].intValue
            self.humodotyLabel.text = "\(humidity)"
            
            self.iconImageView.image = icon
        } else {
            print("Unable load weather info")
        }
    }
    
    
    func failure() {
        // No connection
        let networkController = UIAlertController(title: "Error",
                                                  message: "No connection!",
                                                  preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        networkController.addAction(okButton)
        self.present(networkController, animated: true, completion: nil)
    }
    
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location!)
        
        self.activityIndicator()
        
        let currentLocation = locations.last as CLLocation!
        
        if (currentLocation!.horizontalAccuracy > 0) {
            // Stop update locations to save battery life
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!,
                                                    (currentLocation?.coordinate.longitude)!)
            self.openWeather.weatherFor(geo: coords)
            print(coords)
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("can't get your location")
    }

}

















