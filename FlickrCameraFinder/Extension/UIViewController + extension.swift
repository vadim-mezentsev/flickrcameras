//
//  UIViewController + extension.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 17/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func informAlert(title: String?, message: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}
