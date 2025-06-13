//
//  Data+Extension.swift
//  Foundly
//
//  Created by mars uzhanov on 09.03.2025.
//

import Foundation

extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
