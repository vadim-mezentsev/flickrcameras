//
//  NetworkError.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import Foundation

struct NetworkError: Error {
    enum ErrorType {
        case invalidRequest
        case invalidResponse
        case invalidJSON
        case flickrError
    }
    
    let message: String
    let type: ErrorType
}
