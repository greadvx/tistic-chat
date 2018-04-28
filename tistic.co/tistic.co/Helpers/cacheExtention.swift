//
//  cacheExtention.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/28/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImageUsingCacheWithUrlString(urlString: String)  {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = cachedImage as? UIImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            if let downloadedImage = UIImage(data: data!) {
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                self.image = downloadedImage
            }
        }.resume()
    }
}
