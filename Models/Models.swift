//
//  Models.swift
//  TaskTango
//
//  Created by mac on 02/08/25.
//


import Foundation

struct RegisterUser: Codable {
    let email: String
    let password: String
    let username: String
}

struct LoginUser: Encodable {
    let username: String
    let password: String
}

// A generic structure for common API responses
struct APIResponse<T: Decodable>: Decodable {
    let data: T?
    let error: String?
    let message: String?
}

// Modified AuthResponse to match a common nested structure
struct AuthResponseData: Decodable {
    let accessToken: String
}

// MARK: - User Models
struct Profile: Codable, Identifiable {
    let id: String
    let username: String
    let email: String
    var avatarURL: URL?
    var bio: String?
    var contact: String?
}

class User: ObservableObject, Identifiable, Equatable, Codable {
    let id: Int
    let stringId: String
    @Published var username: String
    let email: String
    @Published var avatarURL: String?
    @Published var bio: String?
    var contact: String? // Assuming contact doesn't need publishing/doesn't change often
    let isCurrentUser: Bool
    @Published var name: String
    @Published var isOnline: Bool
    @Published var isPremium: Bool // This property must be published to be reactive

    // Manually define CodingKeys for Codable conformance
    private enum CodingKeys: String, CodingKey {
        case id, stringId, username, email, avatarURL, bio, contact, isCurrentUser, name, isOnline, isPremium
    }
    
    // Manually implement Equatable conformance as @Published breaks default synthesis for classes
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.stringId == rhs.stringId
    }

    // Custom Decoder to handle initialization from JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        stringId = try container.decode(String.self, forKey: .stringId)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        contact = try container.decodeIfPresent(String.self, forKey: .contact)
        isCurrentUser = try container.decode(Bool.self, forKey: .isCurrentUser)
        name = try container.decode(String.self, forKey: .name)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
        isPremium = try container.decode(Bool.self, forKey: .isPremium)
    }
    
    // Custom Encoder to handle encoding back to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stringId, forKey: .stringId)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(avatarURL, forKey: .avatarURL)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encodeIfPresent(contact, forKey: .contact)
        try container.encode(isCurrentUser, forKey: .isCurrentUser)
        try container.encode(name, forKey: .name)
        try container.encode(isOnline, forKey: .isOnline)
        try container.encode(isPremium, forKey: .isPremium)
    }
}

// Extension for helper initializers and computed properties
extension User {
    convenience init(
        id: Int,
        stringId: String,
        username: String,
        email: String,
        name: String,
        isOnline: Bool,
        isCurrentUser: Bool,
        isPremium: Bool,
        bio: String? = nil,
        avatarURL: String? = nil
    ) {
        // This helper uses the required designated initializer
        // This helper uses the required designated initializer
        self.init(id: id, stringId: stringId, username: username, email: email, name: name, isOnline: isOnline, isCurrentUser: isCurrentUser, isPremium: isPremium, bio: bio, avatarURL: avatarURL)


    }
    
    // Helper function for URL generation
    var avatarURLObject: URL? {
        guard let avatarURLString = self.avatarURL else {
            return nil
        }
        
        if avatarURLString.hasPrefix("https://") || avatarURLString.hasPrefix("http://") {
            print("DEBUG: Final URL being loaded: \(avatarURLString)")
            return URL(string: avatarURLString)
        } else {
            let fullURLString = "https://tasktango.dev" + avatarURLString
            print("DEBUG: Final URL being loaded: \(fullURLString)")
            return URL(string: fullURLString)
        }
    }
}




// MARK: - Chat Models
struct ChatMessage: Identifiable, Equatable, Codable {
    // Note: The 'id' here needs to match your backend's message ID type,
    // often a String (UUID().uuidString) or Int. I'll assume String for flexibility.
    let id: Int
    let sender: User // Uses your specified User struct (id: UUID, stringId: String)
    let content: String
    let timestamp: Date
    let channelId: String?
    
    // We update the computed property to return the stringId of the sender
    var senderIdString: String {
        return sender.stringId // This now returns a String successfully
    }
}

struct NewMessage: Encodable {
    let content: String
    let senderId: String
    let channelId: String
}

struct ChatChannel: Codable, Identifiable, Hashable {
    // Corrected: The ID must be of type Int to match your backend's data.
    let id: Int
    let name: String
    let isPrivate: Bool
    let members: [String]?

    // You can remove the CodingKeys and custom initializers.
    // The default implementation of Codable and the memberwise initializer
    // will now work correctly with the new Int type for `id`.
}
    // You still need to define your CodingKeys enum inside the struct
 
// MARK: - WebSocket Models
enum WebSocketOutgoingMessage: Encodable {
    case chatMessage(content: String, senderId: String, channelId: String)
    case privateMessage(content: String, senderId: String, recipientId: String)

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .chatMessage(let content, let senderId, let channelId):
            try container.encode("new_message", forKey: .type)
            try container.encode(content, forKey: .content)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(channelId, forKey: .channelId)
        case .privateMessage(let content, let senderId, let recipientId):
            try container.encode("private_message", forKey: .type)
            try container.encode(content, forKey: .content)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(recipientId, forKey: .recipientId)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type, content, senderId, recipientId, channelId
    }
}

struct WebSocketIncomingMessage: Codable {
    var type: String
    var message: ChatMessage
}

// Mock Message Model
struct Message: Identifiable, Decodable {
    // Change this from String to Int
    let id: Int
    
    var userID: Int
    let messageText: String
    let timestamp: Date
    // You might also need a 'sender' property to decode the nested object
    // let sender: Sender // assuming you have a Sender struct

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "sender_id"
        case messageText = "content"
        case timestamp
    }
}

struct Sender: Decodable {
    let id: Int
    let email: String
    let name: String
    let username: String
    let isOnline: Bool
    let isCurrentUser: Bool
    // Note: The "stringId" field might not be needed if you use the Int "id"
    // If you need it, add: let stringId: String
}

struct MessageResponse: Decodable {
    struct DataWrapper: Decodable {
        let messages: [Message]
    }
    let data: DataWrapper
}

struct APIMessage: Decodable {
    let id: Int
    let content: String
    let timestamp: Date
    let sender: Sender // Nested sender object
}

struct APIData: Decodable {
    let messages: [APIMessage]
}

struct UserModel: Codable, Identifiable {
    // These properties match the backend JSON structure exactly
    let id: Int
    let username: String
    let email: String
    let name: String
    let isOnline: Bool
    let isCurrentUser: Bool
    
    // Map the JSON key "stringId" to the Swift property "stringID"
    let stringID: String

    // Define custom mapping for keys that do not match Swift's camelCase style
    private enum CodingKeys: String, CodingKey {
        case id, username, email, name
        case isOnline, isCurrentUser
        case stringID = "stringId" // Maps JSON "stringId" to Swift "stringID"
    }
}

struct MessageModel: Codable, Identifiable {
    let id: Int
    let content: String
    // The timestamp should be handled as a Swift Date object after decoding
    let timestamp: Date
    let sender: UserModel
}

struct MessagesResponse: Codable {
    let data: MessageDataWrapper
}

// Used to capture the structure: {"messages": [...]}
struct MessageDataWrapper: Codable {
    let messages: [MessageModel]
}
