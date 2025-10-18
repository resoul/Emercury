public struct GetAudiencesResponse: Decodable {
    let audiences: [Audience]
    
    public struct Audience: Decodable {
        let id: String
        let name: String
        let size: String
        let subscribersCount: String
        let unsubscribed: String
        let status: String
        let isSegment: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case size
            case subscribersCount = "subscribers_count"
            case unsubscribed
            case status
            case isSegment = "is_segment"
        }
    }
}
