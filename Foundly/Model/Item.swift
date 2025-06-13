import Foundation

struct Item: Codable {
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
    let category: UUID
    let subcategory: UUID
    let subsubcategory: UUID

    enum CodingKeys: String, CodingKey {
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
struct ItemResponse: Decodable {
    let items: [Item]
}
