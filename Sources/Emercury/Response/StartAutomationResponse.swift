public struct StartAutomationResponse: Decodable {
    let automation: Message
    
    public struct Message: Decodable {
        let message: String
    }
}
