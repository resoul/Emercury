public extension EmercuryRequest {
    static func getAudiences(includeSegments: Bool = false) -> EmercuryRequest {
        let params: [String: String] = [
            "include_segments" : includeSegments ? "true" : "false"
        ]

        return EmercuryRequest(method: "GetAudiences", parameters: params)
    }
}
