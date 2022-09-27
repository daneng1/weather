//
//  WeatherModel.swift
//  Clima
//
//  Created by Dan Engel on 9/23/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temp: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temp)
    }
    
    //computed property that will return based on the value of another variable
    var conditionName: String {
        switch conditionID {
        case 1..<233:
            return "cloud.bolt"
        case 300..<322:
            return "cloud.drizzle"
        case 500..<531:
            return "cloud.rain"
        case 600..<622:
            return "cloud.snow"
        case 700..<782:
            return "sun.haze"
        case 800:
            return "sun.max"
        default:
            return "cloud.sun"
            
        }
    }
    
}
