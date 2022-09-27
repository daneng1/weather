//
//  ImageManager.swift
//  Clima
//
//  Created by Dan Engel on 9/26/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol ImageManagerDelegate {
    func didUpdateImages(_ imageManager: ImageManager, images: ImageModel)
    
    func didFailWithError(error: Error)
}

struct ImageManager {
    
    let unslpashURL = "https://api.unsplash.com/"
    
    var delegate: ImageManagerDelegate?
    
    func fetchImage(cityName: String) {
        if let unsplashAPI = ProcessInfo.processInfo.environment["UNSPLASH_API"] {
            let cityWithoutSpaces = cityName.replacingOccurrences(of: " ", with: "+")
            
            let urlString = "\(unslpashURL)search/photos?per_page=1&query=\(cityWithoutSpaces)+skyline&client_id=\(String(describing: unsplashAPI))"
            performRequest(with: urlString)
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
                
                if let safeData = data {
                    if let photo = self.parseJSON(safeData) {
                        self.delegate?.didUpdateImages(self, images: photo)
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
    
    func parseJSON(_ imageData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            let url = decodedData.results[0].urls.full
            
            let image = ImageModel(url: url)
            
            return image
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
