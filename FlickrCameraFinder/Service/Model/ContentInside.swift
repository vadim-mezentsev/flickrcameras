//
//  ContentInside.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

struct ContentInside: Decodable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
      case content = "_content"
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
    }
}
