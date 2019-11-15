//
//  ViewController.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        networkService.fetchCameraBrands { result in
//            switch result {
//            case .success(let cameraBrands):
//                print(cameraBrands)
//            case .failure(let error):
//                print(error.message)
//            }
//        }
        
        networkService.fetchCameraModels(for: "apple") { result in
            switch result {
            case .success(let cameraBrands):
                print(cameraBrands)
            case .failure(let error):
                print(error.message)
            }
        }
    }


}

