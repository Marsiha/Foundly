//
//  QR.swift
//  
//
//  Created by mars uzhanov on 20.03.2025.
//

import Foundation

struct QR: Codable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case profilePicture = "profile_picture"
    }
}
