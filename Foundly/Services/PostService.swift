//
//  PostService.swift
//  Foundly
//
//  Created by mars uzhanov on 08.03.2025.
//

import Foundation
import UIKit
import Alamofire

class PostService {
    
    public static let shared = PostService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:8000"

    public func postItemData(item: Item, image: UIImage, completion: @escaping (Item?, UIImage?, Error?) -> Void) {
        
    }

}
