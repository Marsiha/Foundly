//
//  MapItem.swift
//  Foundly
//
//  Created by mars uzhanov on 08.05.2025.
//

import Foundation

struct MapItem: Codable {
    let id: String
    let photos: [Photo]
    let title: String?
    let itemType: String
    let description: String
    let latitude: Double
    let longitude: Double
    let address: String
    let status: String
    let email: String
    let date: String
    let phoneNumber: String
    let category: String
    let subcategory: String
    let subsubcategory: String

    enum CodingKeys: String, CodingKey {
        case id
        case photos
        case title
        case itemType = "item_type"
        case description
        case latitude
        case longitude
        case address
        case status
        case email
        case date
        case phoneNumber = "phone_number"
        case category
        case subcategory
        case subsubcategory
    }
}

struct Photo: Codable {
    let image: String
}

struct MapItemResponse: Decodable {
    let items: [MapItem]
}
