//
//  Extensions.swift
//  Clima
//
//  Created by Dan Engel on 9/26/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(_ url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
