import Foundation

class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var isConnected = false
    
    static let shared = WebSocketManager()
    
    private override init() {}
    
    func connect() {
        guard let url = URL(string: "ws://127.0.0.1:8000/ws/chat/") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        // Add Authorization Header from UserDefaults
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        isConnected = true
        
        listen()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    
    private func listen() {
        guard isConnected else { return }
        
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
                
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received message: \(text)")
                    // Handle incoming message here
                    self?.handleMessage(text)
                    
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown message type")
                }
                
                // Continue listening
                self?.listen()
            }
        }
    }
    
    private func handleMessage(_ text: String) {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String,
                   let senderId = json?["sender_id"] as? String {
                    print("Message from \(senderId): \(message)")
                }
            } catch {
                print("Error parsing message: \(error)")
            }
        }
    }
    
    func sendMessage(receiverId: String, message: String) {
        guard isConnected else { return }
        
        let payload: [String: Any] = [
            "receiver_id": receiverId,
            "message": message
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: payload) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let message = URLSessionWebSocketTask.Message.string(jsonString)
                
                webSocketTask?.send(message) { error in
                    if let error = error {
                        print("Send error: \(error)")
                    } else {
                        print("Message sent: \(jsonString)")
                    }
                }
            }
        }
    }
    
    // Handle WebSocket connection state changes
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connected")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith code: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket disconnected with code: \(code)")
        isConnected = false
    }
}
