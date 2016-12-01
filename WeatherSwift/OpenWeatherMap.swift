//
//  OpenWeatherMap.swift
//  WeatherSwift
//
//  Created by Dima Tixon on 21/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

protocol OpenWeatherMapDelegate {
    // reqired
    func updateWeatherInfo(weatherJson: JSON)
    func failure()
}

 // модель погоды
class OpenWeatherMap {
    let weatherUrl = "http://api.openweathermap.org/data/2.5/forecast" // weather
    
    var delagete: OpenWeatherMapDelegate!
    
    
    func weatherFor(city: String) {
        // вместо init  
        let params = ["q" : city, "APPID" : "3aeb0927332507b5d1c47e8cccb8c7b9"]
        setRequest(params: params as [String : AnyObject]?)
    }
    
    func weatherFor(geo: CLLocationCoordinate2D) {
        let params = ["lat": geo.latitude, "lon": geo.longitude,
                      "APPID" : "3aeb0927332507b5d1c47e8cccb8c7b9"] as [String : Any]
        setRequest(params: params as [String : AnyObject]?)
    }
    
    func setRequest(params: [String : AnyObject]?) {
        request(weatherUrl, method: .get, parameters: params).responseJSON { (res) in
            if (res.result.error != nil) {
                self.delagete.failure()
            } else {
                // получим JSON
                let weatherJson = JSON(res.result.value as Any)
                
                DispatchQueue.main.async {
                    self.delagete.updateWeatherInfo(weatherJson: weatherJson)
                }
            }
        }
    }
    
    
    // из секунд делаем строку
    func timeFromUnix(unixTime: Int) -> String {
                
        let timeInsecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInsecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let str = dateFormatter.string(from: weatherDate)
        
        return str
    }
    
    
    func updateWeatherIcon(condition: Int, nightTime: Bool, index: Int) -> UIImage {
        var imageName = String()
        switch (condition, nightTime) {
            // Thunderstorm
            case let (x,y) where x < 300 && y == true: imageName = "11n"
            case let (x,y) where x < 300 && y == false: imageName = "11d"
            // Drizzle
            case let (x,y) where x < 500 && y == true: imageName = "09n"
             case let (x,y) where x < 300 && y == false: imageName = "09d"
            //Rain
            case let (x,y) where x <= 504 && y == true: imageName = "10n"
            case let (x,y) where x <= 504 && y == false: imageName = "10d"
            
            case let (x,y) where x == 511 && y == true: imageName = "13n"
            case let (x,y) where x == 511 && y == false: imageName = "13d"
            
            case let (x,y) where x < 600 && y == true: imageName = "09n"
            case let (x,y) where x < 600 && y == false: imageName = "09d"
            // Snow
            case let (x,y) where x < 700 && y == true: imageName = "13n"
            case let (x,y) where x < 700 && y == false: imageName = "13d"
            // Atmosthere
            case let (x,y) where x < 800 && y == true: imageName = "50n"
            case let (x,y) where x < 800 && y == false: imageName = "50d"
            // Clouds
            case let (x,y) where x == 800 && y == true: imageName = "01n"
            case let (x,y) where x == 800 && y == false: imageName = "01d"
            
            case let (x,y) where x == 801 && y == true: imageName = "02n"
            case let (x,y) where x == 801 && y == false: imageName = "02d"
            
            case let (x,y) where x > 802 || x < 804 && y == true: imageName = "03n"
            case let (x,y) where x > 802 || x < 804 && y == false: imageName = "03d"
            
            case let (x,y) where x == 804 && y == true: imageName = "04n"
            case let (x,y) where x == 804 && y == false: imageName = "04d"
            // Additional
            case let (x,y) where x < 100 && y == true: imageName = "11n"
            case let (x,y) where x < 100 && y == false: imageName = "11d"
            
            case (_,_): imageName = "none"
        }
        let iconImage = UIImage(named: imageName)
        return (iconImage)!
    }
    
    
    func convertTemperature(contry: String, temperature: Double) -> Double {
        
        if (contry == "US") {
            // convert to Farengate
            let temp = round(((temperature - 273.215) * 1.8) + 32)
            
            return temp
        } else {
            // convert to Cel
            return round(temperature - 273.15)
        }
    }
    
    
    func isTimeNight(icon: String) -> Bool {
         // узнали ночь или день
        return icon.range(of: "n") != nil
    }
    
    /*func isTimeNight(weaatherJson: JSON) -> Bool {
        var nightTime = false
        let nowTime = NSDate().timeIntervalSince1970
        let sunrise = weaatherJson["sys"]["sunrise"].doubleValue
        let sunset = weaatherJson["sys"]["sunset"].doubleValue
        
        if (nowTime < sunrise) || (nowTime > sunset) {
            nightTime = true
        }
        return nightTime
    } */
}




















