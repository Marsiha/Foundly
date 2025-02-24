import Foundation

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:8000" // Replace with your backend URL
    
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
        let url = URL(string: "\(baseURL)/verify-email/")! // Replace with your registration endpoint
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
    
    /// A method to sign out the user
    /// - Parameter completion: A completion with an optional error
    public func signOut(completion: @escaping (Error?) -> Void) {
        // Clear saved tokens or session data
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        completion(nil)
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
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(nil, NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token found"]))
            return
        }
        
        let url = URL(string: "\(baseURL)/user")! // Replace with your user data endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(nil, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let username = json?["username"] as? String,
                   let email = json?["email"] as? String,
                   let userUID = json?["userUID"] as? String {
                    let user = User(username: username, email: email, userUID: userUID)
                    completion(user, nil)
                } else {
                    completion(nil, NSError(domain: "InvalidData", code: -1, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
