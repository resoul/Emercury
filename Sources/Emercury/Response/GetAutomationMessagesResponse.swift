public struct GetAutomationMessagesResponse: Decodable {
    let messages: [Message]
    
    public struct Message: Decodable {
        let messageId: String
        let friendlyName: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case friendlyName = "friendly_name"
        }
    }
}
