public extension EmercuryRequest {
    static func getTrackingCode(create: Bool = true) -> EmercuryRequest {
        var shouldCreateTrackingCode: String = "true"
        if !create {
            shouldCreateTrackingCode = "false"
        }
        
        return EmercuryRequest(method: "getTrackingCode", parameters: ["create": shouldCreateTrackingCode])
    }
}
