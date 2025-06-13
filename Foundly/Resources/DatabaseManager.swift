//
//  DatabaseManager.swift
//  Foundly
//
//  Created by mars uzhanov on 02.05.2025.
//

import Foundation
import FirebaseDatabase

struct ChatUser {
    let email: String
    let firstName: String
    let lastName: String
    
    var safeEmail: String {
        var safeEmail = email
        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://foundly-3c38e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}


//MARK: - Account Management
extension DatabaseManager {
    
    ///Insert new user to database
    public func insertUser(with user: ChatUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { error, _ in
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    
                    userCollection.append(newElement)
                    
                    self.database.child("users").setValue(userCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            }
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedFetch))
                return
            }
            
            completion(.success(value))
        }
    }
    
    public enum DatabaseError: Error {
        case failedFetch
    }
}

extension DatabaseManager {
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedFetch))
                return
            }
            completion(.success(value))
        }
    }
}

//MARK: - Conversations / sending messages
extension DatabaseManager {
    
    public func createConversation(with otherUserEmail: String, firstMessage: Message, name: String, completion: @escaping (Bool) -> Void) {
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
            print("hello 1")
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            var message = ""
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            switch firstMessage.kind{
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            //Update recipient conversation entry
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    conversations.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                } else  {
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            }
            
            //Update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        print("hello 2")
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name, conversionId: conversationId, firstMessage: firstMessage, completion: completion)
                })
            } else {
                userNode["conversations"] = [
                    newConversationData
                ]
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        print("hello 3")
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name, conversionId: conversationId, firstMessage: firstMessage, completion: completion)
                })
            }
        }
        
    }
    
    private func finishCreatingConversation(name: String, conversionId: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        var message = ""
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        switch firstMessage.kind{
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let userEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKingString,
            "content": message,
            "date": dateString,
            "sender_email": safeEmail,
            "is_read": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        
        database.child("\(conversionId)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        
        database.child("\(email)/conversations").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap { dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessageDictionary = dictionary["latest_message"] as? [String: Any],
                      let latestMessageText = latestMessageDictionary["message"] as? String,
                      let date = latestMessageDictionary["date"] as? String,
                      let isRead = latestMessageDictionary["is_read"] as? Bool else {
                    return nil
                }
                
                let latestMessageObject = LatestMessage(
                    date: date,
                    text: latestMessageText,
                    isRead: isRead
                )
                return Conversation(
                    id: conversationId,
                    name: name,
                    otherUserEmail: otherUserEmail,
                    latestMessage: latestMessageObject
                )
            }
            completion(.success(conversations))
        }
        
    }
    
    public func getAllMessagesForConversations(for id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        
        database.child("\(id)/messages").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedFetch))
                return
            }
            
            let messages: [Message] = value.compactMap { dictionary in
                let name = dictionary["name"] as? String
                let isRead = dictionary["is_read"] as? Bool
                let messageId = dictionary["id"] as? String
                let content = dictionary["content"] as? String
                let senderEmail = dictionary["sender_email"] as? String
                let type = dictionary["type"] as? String
                let dateString = dictionary["date"] as? String
                let date = dateString.flatMap { ChatViewController.dateFormatter.date(from: $0) }
                
                if name == nil { print("Missing: name") }
                if isRead == nil { print("Missing: is_read") }
                if messageId == nil { print("Missing: id") }
                if content == nil { print("Missing: content") }
                if senderEmail == nil { print("Missing: sender_email") }
                if type == nil { print("Missing: type") }
                if dateString == nil { print("Missing: date (string)") }
                if date == nil { print("Missing: date (parsed)") }
                
                guard let name, let isRead, let messageId, let content, let senderEmail, let type, let date else {
                    return nil
                }
                
                let sender = Sender(photo: "", senderId: senderEmail, displayName: name)
                
                return Message(
                    sender: sender,
                    messageId: messageId,
                    sentDate: date,
                    kind: .text(content)
                )
            }
            print(messages)
            completion(.success(messages))
        }
        
    }
    
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return completion(false)
        }
        
        let currentEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        
        database.child("\(conversation)/messages").observeSingleEvent(of: .value ) { [weak self] snapshot in
            
            guard let strongSelf = self else {
                return
            }
            
            guard var currentMessage = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageDate = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            var message = ""
            switch newMessage.kind{
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            guard let userEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKingString,
                "content": message,
                "date": dateString,
                "sender_email": safeEmail,
                "is_read": false,
                "name": name
            ]
            
            currentMessage.append(newMessageEntry)
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessage) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                                
                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                    guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
                        return completion(false)
                    }
                    
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "content": message
                    ]
                    
                    var targetConversation: [String: Any]?
                    var position = 0
                    
                    for conversations in currentUserConversations {
                        if let currentId = conversations["id"] as? String, currentId == conversation {
                            targetConversation = conversations
                            break
                        }
                        position += 1
                    }
                    targetConversation?["latest_message"] = updatedValue
                    guard let finalConversation = targetConversation else {
                        return completion(false)
                    }
                    currentUserConversations[position] = finalConversation
                    strongSelf.database.child("\(currentEmail)/conversations").setValue(currentUserConversations) { error, _ in
                        guard error == nil else {
                            return completion(false)
                        }
                        
                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { snapshot in
                            guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                                return completion(false)
                            }
                            
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "content": message
                            ]
                            
                            var targetConversation: [String: Any]?
                            var position = 0
                            
                            for conversations in otherUserConversations {
                                if let currentId = conversations["id"] as? String, currentId == conversation {
                                    targetConversation = conversations
                                    break
                                }
                                position += 1
                            }
                            targetConversation?["latest_message"] = updatedValue
                            guard let finalConversation = targetConversation else {
                                return completion(false)
                            }
                            otherUserConversations[position] = finalConversation
                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(otherUserConversations) { error, _ in
                                guard error == nil else {
                                    return completion(false)
                                }
                                completion(true)
                            }
                        }
                        
                        completion(true)

                    }
                }
                
                completion(true)

            }
        }
    }
    
}
