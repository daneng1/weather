//
//  ImageData.swift
//  Clima
//
//  Created by Dan Engel on 9/26/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct ImageData: Codable {
    let results: [Images]
}

struct Images: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
}
