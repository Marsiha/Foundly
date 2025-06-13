//
//  Category.swift
//  Foundly
//
//  Created by mars uzhanov on 12.03.2025.
//

import Foundation


struct Category: Codable {
    let id: String
    let name: String
    let photo: String
}

struct Subcategory: Codable {
    let id: String
    let name: String
    let category: String
}

struct Subsubcategory: Codable {
    let id: String
    let name: String
    let category: String
    let subcategory: String
}

struct CategoryResponse: Codable {
    let category: [Category]
    let subcategory: [Subcategory]
    let subsubcategory: [Subsubcategory]
}
