//
//  ChangePassword.swift
//  Foundly
//
//  Created by mars uzhanov on 28.03.2025.
//

import Foundation

struct ChangePassword: Codable {
    let currentPassword: String
    let newPassword: String
    let newPasswordConfirmation: String
    
    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case newPassword = "new_password"
        case newPasswordConfirmation = "new_password_confirmation"
    }
}
