//
//  ServiceDecodableData.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import Foundation


struct Animal: Decodable {
    let id: Int
    let organization_id: String
    let url: String
    let photos: [[String: String]]
    let videos: [[String: String]]
    let name: String
}

struct Animals: Decodable {
    var animals: [Animal]
}

