//
//  PostService.swift
//  Foundly
//
//  Created by mars uzhanov on 08.03.2025.
//

import Foundation
import UIKit

class PostService {
    
    public static let shared = PostService()
    private init() {}
    
    private let baseURL = "https://foundly.kz/"
    
    let url: URL = URL(string: "https://foundly.kz/item/create/")!
    let boundary: String = "Boundary-\(UUID().uuidString)"
    
    public func postItemData(item: Item, imageArray: [UIImage], completion: @escaping (Bool) -> Void) {
        let requestBody = self.multipartFormDataBody(self.boundary, item, imageArray)
        let request = self.generateRequest(httpBody: requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("✅ Upload successful! Status code: \(httpResponse.statusCode)")
                        print("📝 Response: \(responseString)")
                        completion(true)
                    } else {
                        print("❌ Upload failed: no data or invalid encoding.")
                        completion(false)
                    }
                } else {
                    print("❌ Upload failed. Status code: \(httpResponse.statusCode)")
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("💥 Error message: \(errorMessage)")
                    }
                    completion(false)
                }
            } else {
                print("❌ Invalid HTTP response.")
                completion(false)
            }
        }
        task.resume()
    }
    
    private func generateRequest(httpBody: Data) -> URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func multipartFormDataBody(_ boundary: String, _ item: Item, _ images: [UIImage]) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        // ✅ Append individual fields
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"title\"\(lineBreak + lineBreak)")
        body.append("\((item.title ?? "") + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"item_type\"\(lineBreak + lineBreak)")
        body.append("\(item.itemType + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"description\"\(lineBreak + lineBreak)")
        body.append("\(item.description + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"latitude\"\(lineBreak + lineBreak)")
        body.append("\(item.latitude)\(lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"longitude\"\(lineBreak + lineBreak)")
        body.append("\(item.longitude)\(lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"address\"\(lineBreak + lineBreak)")
        body.append("\(item.address + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"status\"\(lineBreak + lineBreak)")
        body.append("\(item.status + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"email\"\(lineBreak + lineBreak)")
        body.append("\(item.email + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"date\"\(lineBreak + lineBreak)")
        body.append("\(item.date + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"phone_number\"\(lineBreak + lineBreak)")
        body.append("\(item.phoneNumber + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"category\"\(lineBreak + lineBreak)")
        body.append("\(item.category.uuidString + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"subcategory\"\(lineBreak + lineBreak)")
        body.append("\(item.subcategory.uuidString + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"subsubcategory\"\(lineBreak + lineBreak)")
        body.append("\(item.subsubcategory.uuidString + lineBreak)")
        
        // ✅ Append image data
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.99) {
                let fileName = "image_\(index).jpg"
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"photos\"; filename=\"\(fileName)\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                body.append(imageData)
                body.append(lineBreak)
            }
        }
        
        // ✅ Close boundary
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
}
