import Foundation

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    private let baseURL = "https://foundly.kz" // Replace with your backend URL
    
    /// A method to sign in the user
    /// - Parameters:
    ///   - userRequest: The user's login information (email, password)
    ///   - completion: A completion with an optional error
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(baseURL)/login/")! // Replace with your login endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": userRequest.username,
            "password": userRequest.password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            // Parse the response to extract tokens or user data
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let accessToken = json?["access"] as? String,
                       let refreshToken = json?["refresh"] as? String {
                        // Save tokens to Keychain or UserDefaults
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    }
                } catch {
                    completion(error)
                    return
                }
            }
            
            completion(nil)
        }
        task.resume()
    }
    
    public func registerEmail(with email: String, isRegister: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/register-email/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "is_register": isRegister
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error:", error.localizedDescription)
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📬 Status code:", httpResponse.statusCode)
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("📦 Response data:", responseString)
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }

            completion(true, nil)
        }
        task.resume()
    }
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: The user's information (email, password, username)
    ///   - completion: A completion with two values...
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if the request fails
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/register/")! // Replace with your registration endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": userRequest.email,
            "first_name": userRequest.firstName,
            "last_name": userRequest.lastName,
            "password": userRequest.password,
            "phone_number": "",
            "password2": userRequest.password2
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    public func verifyEmail(with verifyRequest: VerifyRegisterCodeRequest, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/verify-email/\(verifyRequest.email)/")! // Replace with your registration endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "code": verifyRequest.code
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/forgot-password/")! // Replace with your registration endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "No valid HTTP response received."]))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(true, nil)
            case 400...499:
                completion(false, NSError(domain: "ClientError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid request. Please check your input."]))
            case 500...599:
                completion(false, NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server issue. Please try again later."]))
            default:
                completion(false, NSError(domain: "UnexpectedError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response from server."]))
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    public func verifyResetCode(with verifyRequest: VerifyRegisterCodeRequest, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/verify-reset-code/")! // Replace with your registration endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": verifyRequest.email,
            "code": verifyRequest.code
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    public func resetPassword(with newPasswordRequest: NewPasswordRequest, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/reset-password/")! // Replace with your registration endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": newPasswordRequest.email,
            "new_password": newPasswordRequest.password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    
    
    /// A method to sign out the user
    /// - Parameter completion: A completion with an optional error
    public func signOut(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("No refresh token available.")
            clearUserSession()
            completion(true)
            return
        }
        
        let url = URL(string: "\(baseURL)/logout/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["refresh": refreshToken])
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Failed to sign out: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Clear tokens after successful logout
            self.clearUserSession()
            completion(true)
        }
        task.resume()
    }
    
    // Helper method to clear user session
    private func clearUserSession() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        print("User session cleared.")
    }
    
    
    /// A method to request a password reset
    /// - Parameters:
    ///   - email: The user's email address
    ///   - completion: A completion with an optional error
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(baseURL)/forgot-password")! // Replace with your forgot password endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            completion(nil)
        }
        task.resume()
    }
    
    /// A method to fetch the current user's data
    /// - Parameter completion: A completion with the user data or an error
    public func fetchUserData(completion: @escaping (User?, Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(nil, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token available"]))
            return
        }
        
        let url = URL(string: "\(baseURL)/profile/")! // Replace with your user endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    print("Decoded user: \(user)")
                    completion(user, nil)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    public func fetchItemData(completion: @escaping ([MapItem]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/item/map/") else {
            completion(nil, NSError(domain: "URLError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                do {
                    let itemResponse = try JSONDecoder().decode(MapItemResponse.self, from: data)
                    print("Decoded items: \(itemResponse.items)")
                    completion(itemResponse.items, nil)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    public func postItemData(item: Item, completion: @escaping (Item?, Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(nil, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token available"]))
            return
        }
        
        let url = URL(string: "\(baseURL)/item/create/")! // Replace with actual API endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(item)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "Invalid JSON"
            print("JSON Payload: \(jsonString)")  // Debugging Step
            request.httpBody = jsonData
        } catch {
            print("Encoding Error: \(error)")
            completion(nil, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Server Response: \(responseString)")
                    }
                    completion(nil, NSError(domain: "InvalidResponse", code: httpResponse.statusCode, userInfo: nil))
                    return
                }
            }
            
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                do {
                    let item = try JSONDecoder().decode(Item.self, from: data)
                    print("Decoded item: \(item)")
                    completion(item, nil)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    public func fetchQRCodeData(from urlString: String, completion: @escaping (Result<QR, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
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
                let qrCodeData = try decoder.decode(QR.self, from: data)
                completion(.success(qrCodeData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
