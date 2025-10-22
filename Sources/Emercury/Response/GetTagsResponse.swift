public struct GetTagsResponse: Decodable {
    let tags: [Tag]
    
    public struct Tag: Decodable {
        let tagId: String
        let tagName: String
        
        enum CodingKeys: String, CodingKey {
            case tagId = "tag_id"
            case tagName = "tag_name"
        }
    }
}
