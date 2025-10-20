public extension EmercuryRequest {
    static func updateAutomationStatus(automationId: Int, enable: Bool) -> EmercuryRequest {
        let params = [
            "automation_id": "\(automationId)",
            "enable": "\(enable)"
        ]
        
        return EmercuryRequest(method: "updateAutomationStatus", parameters: params)
    }
}
