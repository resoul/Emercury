public struct GetAudiencesResponse: Decodable {
    let audience: [Audience]
}

public struct Audience: Decodable {
    let id: Int
    let name: String
    let size: Int
    let subscribersCount: String
    let unsubscribed: String
    let status: Int
    let isSegment: Int
    
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
