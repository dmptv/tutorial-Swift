//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Dima Tixon on 21/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

import UIKit



class ViewController: UIViewController { // 3aeb0927332507b5d1c47e8cccb8c7b9
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    let url = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=3aeb0927332507b5d1c47e8cccb8c7b9"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stringURL = URL(string: url)
        
//        let weatherObject = NSData(contentsOf: stringURL!)
//        print(weatherObject as Any)

        // мы здесь на главном потоке
        let session = URLSession.shared
        
        let task = session.downloadTask(with: stringURL!) {
            (location:  URL?, response: URLResponse?, error: Error?) in
            
            do {
            let weatherData = try Data(contentsOf: stringURL!)      
            
            let weatherJSON = try JSONSerialization.jsonObject(with: weatherData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                
                let weather = OpenWeatherMap(weatherJson: weatherJSON as NSDictionary) // в модель передали дикт
                
                print(weather.nameCity)
                print(weather.temp)
                print(weather.description)
                print(weather.currentTime!)
                print(weather.icon!)
                
                // изм на UI надо делать на главн потоке
                DispatchQueue.main.async {
                    self.iconImageView.image = weather.icon
                }
                
                // тест для гитхаба
                
                
            } catch {
                print("json error: \(error)")
            }
            
        }
        

        task.resume()

    }

}

















