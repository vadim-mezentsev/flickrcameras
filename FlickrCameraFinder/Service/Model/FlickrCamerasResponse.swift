//
//  FlickrCamerasBrandModelsResponse.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

struct FlickrCamerasResponse: FlickrResponse {
    let stat: FlickrResponseStutus
    let code: Int?
    let message: String?
    let cameras: FlickrCameras?
}

struct FlickrCameras: Decodable {
    let brand: String
    let camera: [Camera]
}

struct Camera: Decodable {
    let id: String
    let name: ContentInside<String>
    let details: CameraDetails?
    let images: CameraImages?
}

struct CameraDetails: Decodable {
    let megapixels: ContentInside<String>?
    let lcdScreenSize: ContentInside<String>?
    let memoryType: ContentInside<String>?
}

struct CameraImages: Decodable {
    let small: ContentInside<String>?
    let large: ContentInside<String>?
}
