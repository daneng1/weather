//
//  WeatherData.swift
//  Clima
//
//  Created by Dan Engel on 9/22/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let name: String
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Float
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let main: String
    let description: String
    let id: Int
}
