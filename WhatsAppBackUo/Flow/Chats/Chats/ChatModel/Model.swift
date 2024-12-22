import Foundation

struct DialogueModel: Codable {
    let id: UUID
    let participants: [String]
    let messages: [MessageModel]
    let mediaPaths: [String]
    let documentPaths: [String]
    let lastmessdate : Date
    let lastMessage: String
}

struct MessageModel: Codable {
    let id: UUID
    let sender: String
    let content: String
    let contentType: ContentType
    let timestamp: Date
}

enum ContentType: String, Codable {
    case text
    case media
}


