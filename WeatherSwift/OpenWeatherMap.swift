//
//  OpenWeatherMap.swift
//  WeatherSwift
//
//  Created by Dima Tixon on 21/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

import Foundation
import UIKit

class OpenWeatherMap {

    var nameCity: String
    var temp: Int
    
    var description: String
    var currentTime: String?
    var icon: UIImage?
    
    init(weatherJson: NSDictionary) {
        nameCity = weatherJson["name"] as! String
        let main = weatherJson["main"] as! NSDictionary
        temp = main["temp"] as! Int
        
        let weather = weatherJson["weather"] as! NSArray
        let zero = weather[0] as! NSDictionary
        description = zero["description"] as! String
        let dt = weatherJson["dt"] as! Int
        currentTime = timeFromUnix(unixTime: dt)
        
        let strIcon = zero["icon"] as! String
        icon = weatherIcon(stringIcon: strIcon)
        
    }
    
    func timeFromUnix(unixTime: Int) -> String {
        let timeInsecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInsecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: weatherDate)
    }
    
    func weatherIcon(stringIcon: String) -> UIImage {
        
        let imageName: String
        
        switch stringIcon {
        case "01d": imageName = "06.png"
        case "04n": imageName = "08.png"
        default: imageName = "01"
        }
        
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
}
















