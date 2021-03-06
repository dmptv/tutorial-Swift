//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Dima Tixon on 21/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

import UIKit
import CoreLocation


// "http://api.openweathermap.org/data/2.5/weather?
// q=London,uk&
// APPID=3aeb0927332507b5d1c47e8cccb8c7b9"

class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humodotyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var time1Text: String!
    var time2Text: String!
    var time3Text: String!
    var time4Text: String!
    
    var temp1Text: String!
    var temp2Text: String!
    var temp3Text: String!
    var temp4Text: String!
    
    
    var openWeather = OpenWeatherMap()
    // сделали экзэмпляр класса OpenWeatherMap (владелец протокола)
    
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

        self.openWeather.delagete = self
        
        // настроим locationManager
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
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.default) { (action)->Void in
            
            if let textField = (alert.textFields?.first) as UITextField! {
                self.activityIndicator()
                self.openWeather.weatherFor(city: textField.text!)
                // загрузка данных
            }
            
        }
        
        alert.addAction(ok)
        
        alert.addTextField { (textFiled)->Void in
            // добавили тексфилд в алерт
            textFiled.placeholder = "City Name"
        }
        
        self.present(alert, animated: true, completion: nil)
        // презентуем алерт контролер
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
         // сюда пришел JSON полученный by alamofire
    func updateWeatherInfo(weatherJson: JSON) {
        print(weatherJson)
        
        hud.hide(animated: true)
        
        // распихаем JSON
        if let tempResult = weatherJson["list"][0]["main"]["temp"].double {
            
            // Get country
            let country = weatherJson["city"]["country"].stringValue
            
            // Get city name
            let cityName = weatherJson["city"]["name"].stringValue
            self.cityNameLabel.text = "\(cityName), \(country) test test test"
            
            // Get time
            let now = Int(NSDate().timeIntervalSince1970)
            // current time
            let timeToStr = openWeather.timeFromUnix(unixTime: now)
            self.timeLabel.text = "At \(timeToStr) it is"
            
            // Get convert temperature
            let temperature = openWeather.convertTemperature(contry: country,
                                                             temperature: tempResult)
            self.tempLabel.text = "\(temperature)º"
            
            // get icon
            let weather = weatherJson["list"][0]["weather"][0]
            let condition = weather["id"].intValue
            let iconStr = weather["icon"].stringValue
            let nightTime = openWeather.isTimeNight(icon: iconStr)
            let icon = openWeather.updateWeatherIcon(condition: condition,
                                                     nightTime: nightTime,
                                                         index: 0)
            self.iconImageView.image = icon
            
            // Get description
            let descr = weather["description"].stringValue
            self.descriptionLabel.text = descr
            
            // Get speed wind
            let speed = weatherJson["list"][0]["wind"]["speed"].doubleValue
            self.speedWindLabel.text = "\(speed)"
            
            // Get humididty
            let humidity = weatherJson["list"][0]["main"]["humidity"].intValue
            self.humodotyLabel.text = "\(humidity)"
            
            // для следующих дней
            for index in 1...4 {
                if let tempResult = weatherJson["list"][index]["main"]["temp"].double {
                    
                    
                    // Get convert temperature
                    let temperature =
                        openWeather.convertTemperature(contry: country,
                                                  temperature: tempResult)
                    
                    let tempStr: String = "\(temperature)"
                    
                    if (index == 1) {
                        temp1Text = tempStr
                    } else if (index == 2) {
                        temp2Text = tempStr
                    } else if (index == 3) {
                        temp3Text = tempStr
                    } else if (index == 4) {
                        temp4Text = tempStr
                    }
                    
                    // Get forecast time
                    let forecasttime = weatherJson["list"][index]["dt"].intValue
                    
                    let timeToStr = openWeather.timeFromUnix(unixTime: forecasttime)
                    
                    if (index == 1) {
                        time1Text = timeToStr
                    } else if (index == 2) {
                        time2Text = timeToStr
                    } else if (index == 3) {
                        time3Text = timeToStr
                    } else if (index == 4) {
                        time4Text = timeToStr
                    }
                    
                    let weather = weatherJson["list"][index]["weather"][0]
                    let iconStr = weather["icon"].stringValue
                    let nightTime = openWeather.isTimeNight(icon: iconStr)
                    // узнали ночь или день
                    let icon = openWeather.updateWeatherIcon(condition: condition,
                                                             nightTime: nightTime,
                                                                 index: index)
                    self.iconImageView.image = icon

                }
                
            }
            
            
        } else {
            print("Unable load weather info")
        }
    }
    
    
    func failure() {
        // No connection
        let networkController =
            UIAlertController(title: "Error",
                            message: "No connection!",
                     preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "OK",
                                     style: UIAlertActionStyle.default,
                                     handler: nil)
        
        networkController.addAction(okButton)
        self.present(networkController,
                     animated: true,
                     completion: nil)
    }
    
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations
        locations: [CLLocation]) {
        // print(manager.location!)

        self.activityIndicator()
        
        // возьмем наш локэйшн
        let currentLocation = locations.last as CLLocation!
        
        if (currentLocation!.horizontalAccuracy > 0) {
            // Stop update locations to save battery life
            locationManager.stopUpdatingLocation()
            
            // пердадим наши координаты 
            let coords =
            CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!,
                                       (currentLocation?.coordinate.longitude)!)
            self.openWeather.weatherFor(geo: coords)
            //print(coords)
        }
    }
    

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
        print("can't get your location")
    }
    
    //MARK: - Prepare for seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moreInfo" {
            let forecastController = segue.destination as!
            ForecastViewController
            
            forecastController.time1 = time1Text
            forecastController.time2 = time2Text
            forecastController.time3 = time3Text
            forecastController.time4 = time4Text
            
            forecastController.temp1 = temp1Text
            forecastController.temp2 = temp2Text
            forecastController.temp3 = temp3Text
            forecastController.temp4 = temp4Text
            
        }
    }
    

}

















