public extension EmercuryRequest {
    static func getSubscribers(audienceId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "GetSubscribers", parameters: ["audience_id": "\(audienceId)"])
    }
}
