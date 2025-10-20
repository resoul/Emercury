public extension EmercuryRequest {
    static func getAutomationMessages(automationId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getAutomationMessages", parameters: ["automation_id": "\(automationId)"])
    }
}
