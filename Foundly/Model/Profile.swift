//
//  Profile.swift
//  Foundly
//
//  Created by mars uzhanov on 28.03.2025.
//

import Foundation

struct ProfileEdit: Codable {
    
    let username: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        
    }
    
}
