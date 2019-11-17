//
//  UIImageView + extension.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 17/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(from url: URL) {
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }
        dataTask.resume()
    }
}
