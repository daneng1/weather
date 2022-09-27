//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var imageURL: String = "https://images.unsplash.com/photo-1544413660-299165566b1d?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwyNDA3Njd8MHwxfHNlYXJjaHw3fHxsb3MlMjBhbmdlbGVzJTIwc2t5bGluZXxlbnwwfHx8fDE2NjQzMDM0ODM&ixlib=rb-1.2.1&q=80"
    
    var weatherManager = WeatherManager()
    var imageManager = ImageManager()
    let locationManager = CLLocationManager()

    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        imageManager.delegate = self
        weatherManager.delegate = self
        // This connects the text field to the Go button in the keyboard
        searchTextField.delegate = self
        
        updateImageView(imageURL)
        
        weatherStackView.layer.cornerRadius = 10
        weatherStackView.layer.cornerCurve = .continuous
    }
    
    func updateImageView(_ image: String) {
        backgroundImage.load(URL(string: image)! )
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }

}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
        // this is the method that allows the Go button to trigger an action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
        // delegate for when the text field editing is done, reset it to an empty string
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            imageManager.fetchImage(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager,  weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - ImageManagerDelegate

extension WeatherViewController: ImageManagerDelegate {
    func didUpdateImages(_ imageManager: ImageManager, images: ImageModel) {
        
        DispatchQueue.main.async {
            self.updateImageView(images.url)
        }
        print(images.url)
        
    }
}

