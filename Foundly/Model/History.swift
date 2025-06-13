//
//  History.swift
//  Foundly
//
//  Created by mars uzhanov on 03.04.2025.
//

import Foundation

struct HistoryResponse: Decodable {
    let history: [HistoryItem]
}

struct HistoryItem: Decodable {
    let id: UUID
    let title: String
    let itemType: String
    let description: String
    let latitude: Double
    let longitude: Double
    let date: String
    let address: String
    let status: String
    let phoneNumber: String
    let user: UUID
    let category: UUID
    let subcategory: UUID
    let subsubcategory: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, latitude, longitude, date, address, status, user, category, subcategory, subsubcategory
        case itemType = "item_type"
        case phoneNumber = "phone_number"
    }
}
