public extension EmercuryRequest {
    static func getSubscribersByTag(audienceID: Int, tag: String) -> EmercuryRequest {
        let params: [String: String] = [
            "audience_id": "\(audienceID)",
            "tag": tag
        ]

        return EmercuryRequest(method: "getSubscribersByTag", parameters: params)
    }
}
