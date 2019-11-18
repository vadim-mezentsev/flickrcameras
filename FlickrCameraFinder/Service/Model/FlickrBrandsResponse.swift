//
//  FlickrCamerasBrandsResponse.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

struct FlickrBrandsResponse: FlickrResponse {
    let stat: FlickrResponseStutus
    let code: Int?
    let message: String?
    let brands: FlickrBrands?
}

struct FlickrBrands: Decodable {
    let brand: [Brand]
}

struct Brand: Decodable {
    let id: String
    let name: String
}
