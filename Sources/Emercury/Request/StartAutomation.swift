
public extension EmercuryRequest {
    static func startAutomation(
        campaignID: String,
        email: String,
        additionalParams: [String: String] = [:]
    ) -> EmercuryRequest {
        var params = additionalParams
        params["campaign_id"] = campaignID
        params["email"] = email
        return EmercuryRequest(method: "startAutomation", parameters: params)
    }
}
