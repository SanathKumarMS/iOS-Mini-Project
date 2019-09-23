//
//  Extension+UIImageView.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 23/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

let cache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageWithURL(urlString: String) {
        self.image = nil
        
        if let cachedImage = cache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        cache.setObject(downloadedImage, forKey: urlString as NSString)
                        self.image = downloadedImage
                    }
                }
            }
        }.resume()
    }
}
