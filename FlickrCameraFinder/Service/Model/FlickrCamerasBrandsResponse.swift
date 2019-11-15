//
//  FlickrCamerasBrandsResponse.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

struct FlickrCamerasBrandsResponse: FlickrResponse {
    let stat: FlickrResponseStutus
    let code: Int?
    let message: String?
    let brands: FlickrCameraBrands?
}

struct FlickrCameraBrands: Decodable {
    let brand: [FlickrCameraBrand]
}

struct FlickrCameraBrand: Decodable {
    let id: String
    let name: String
}
