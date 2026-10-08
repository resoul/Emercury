public extension EmercuryRequest {
    static func startAutomation(campaignID: String, email: String) -> EmercuryRequest {
        let params: [String: String] = [
            "campaign_id": campaignID,
            "email": email
        ]

        return EmercuryRequest(method: "startAutomation", parameters: params)
    }
}
