//
//  HistoryService.swift
//  Foundly
//
//  Created by mars uzhanov on 03.04.2025.
//

import Foundation

class HistoryService {
    
    public static let shared = HistoryService()
    private init() {}
    
    private let baseURL = "https://foundly.kz"
    
    func fetchHistoryData(completion: @escaping (Result<[HistoryItem], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token available"])))
            return
        }
        guard let url = URL(string: "\(baseURL)/item/history/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode([HistoryItem].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
