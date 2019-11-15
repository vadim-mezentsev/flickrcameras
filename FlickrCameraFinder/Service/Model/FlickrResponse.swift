//
//  FlickrResponse.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

enum FlickrResponseStutus: String, Decodable {
    case ok
    case fail
}

protocol FlickrResponse: Decodable {
    var stat: FlickrResponseStutus { get }
    var code: Int?  { get }
    var message: String?  { get }
}
