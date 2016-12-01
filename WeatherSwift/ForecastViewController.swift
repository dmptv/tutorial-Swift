//
//  ForecastViewController.swift
//  WeatherSwift
//
//  Created by Dima Tixon on 30/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    // Property
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
    @IBOutlet weak var time4Label: UILabel!
    
    @IBOutlet weak var temp1Label: UILabel!
    @IBOutlet weak var temp2Label: UILabel!
    @IBOutlet weak var temp3Label: UILabel!
    @IBOutlet weak var temp4Label: UILabel!
    
    var time1: String!
    var time2: String!
    var time3: String!
    var time4: String!
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    var temp4: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        time1Label.text = time1
        time2Label.text = time2
        time3Label.text = time3
        time4Label.text = time4

        temp1Label.text = temp1
        temp2Label.text = temp2
        temp3Label.text = temp3
        temp4Label.text = temp4
    }



}










