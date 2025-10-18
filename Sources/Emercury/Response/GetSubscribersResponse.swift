public struct GetSubscribersResponse: Decodable {
    let subscribers: [Subscriber]
    
    public struct Subscriber: Decodable {
        let email: String
        let audienceName: String
        
        enum CodingKeys: String, CodingKey {
            case email
            case audienceName = "audience_name"
        }
    }
}
