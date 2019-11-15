//
//  FlickrUrlHelper.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import Foundation

class FlickrUrlHelper {
    
    private enum QueryItemKey: String {
        case apiKey = "api_key"
        case format = "format"
        case noJsonCallback = "nojsoncallback"
        case method = "method"
        case brand = "brand"
    }
    
    private let scheme = "https"
    private let host = "api.flickr.com"
    private let rootPath = "/services/rest/"
    private let queryItems: [QueryItemKey: String] = [
        .apiKey: "ff2753beb993e601c169b5fa51cb6663",
        .format: "json",
        .noJsonCallback: "1"
    ]
    
    private var urlComponents: URLComponents {
        get {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = rootPath
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.rawValue, value: $1) }
            return urlComponents
        }
    }

    func fetchCameraBrandsUrl() -> URL {
        var urlComponents = self.urlComponents
        let methodName = "flickr.cameras.getBrands"
        urlComponents.queryItems?.append(URLQueryItem(name: QueryItemKey.method.rawValue, value: methodName))
        return urlComponents.url!
    }
    
    func fetchCameraModelsUrl(for brand: String) -> URL {
        var urlComponents = self.urlComponents
        let methodName = "flickr.cameras.getBrandModels"
        urlComponents.queryItems?.append(URLQueryItem(name: QueryItemKey.method.rawValue, value: methodName))
        urlComponents.queryItems?.append(URLQueryItem(name: QueryItemKey.brand.rawValue, value: brand))
        return urlComponents.url!
    }
}
