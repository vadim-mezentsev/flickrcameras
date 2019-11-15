//
//  FlickrCamerasBrandModelsResponse.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

struct FlickrCamerasBrandModelsResponse: FlickrResponse {
    let stat: FlickrResponseStutus
    let code: Int?
    let message: String?
    let cameras: FlickrCameras?
}

struct FlickrCameras: Decodable {
    let brand: String
    let camera: [FlickrCamera]
}

struct FlickrCamera: Decodable {
    let id: String
    let name: ContentInside
    let details: FlickrCameraDetails?
    let images: FlickrCameraImages?
}

struct FlickrCameraDetails: Decodable {
    let megapixels: ContentInside?
    let lcdScreenSize: ContentInside?
    let memoryType: ContentInside?
}

struct FlickrCameraImages: Decodable {
    let small: ContentInside?
    let large: ContentInside?
}
