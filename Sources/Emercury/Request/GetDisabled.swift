public extension EmercuryRequest {
    static func getDisabled(campaignId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getDisabled", parameters: ["campaign_id": "\(campaignId)"])
    }
}
