//
//  WeatherManager.swift
//  Clima
//
//  Created by Dan Engel on 9/20/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,  weather: WeatherModel)
    
    func didFailWithError(error: Error)
}

struct WeatherManager {

    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        if let weatherAPIKey = ProcessInfo.processInfo.environment["WEATHER_API"] {
            let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=imperial&appid=\(String(describing: weatherAPIKey))"
            let cityWithoutSpaces = cityName.replacingOccurrences(of: " ", with: "+")
            let urlString = "\(weatherUrl)&q=\(cityWithoutSpaces)"
            print(urlString)
            performRequest(with: urlString)
        } else {
            print("Fatal Error, could not find API key")
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let weatherAPIKey = ProcessInfo.processInfo.environment["WEATHER_API"] {
            let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=imperial&appid=\(String(describing: weatherAPIKey))"
            let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
            performRequest(with: urlString)
        } else {
            print("Fatal error, could not find API key")
        }
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data  {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherID = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: weatherID, cityName: name, temp: temp)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
}
