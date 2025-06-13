import Foundation

class ProfileService {
    
    public static let shared = ProfileService()
    private init() {}
    
    private let baseURL = "https://foundly.kz"
    
    public func fetchProfileData(completion: @escaping (Result<User, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token available"])))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/edit/") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(User.self, from: data)
                completion(.success(userData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func changePassword(with changePassword: ChangePassword, completion: @escaping (Bool, Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(false, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token available"]))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/change-password/") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(changePassword)
            request.httpBody = jsonData
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    completion(true, nil)
                } else {
                    if let data = data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        let error = NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(false, error)
                    } else {
                        completion(false, NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    public func editProfile(with editProfile: ProfileEdit, completion: @escaping (Bool, Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(false, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token available"]))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/edit/") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(editProfile)
            request.httpBody = jsonData
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    completion(true, nil)
                } else {
                    if let data = data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        let error = NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(false, error)
                    } else {
                        completion(false, NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                    }
                }
            }
        }
        
        task.resume()
    }
    
}
