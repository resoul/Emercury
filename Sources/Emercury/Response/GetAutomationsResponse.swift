public struct GetAutomationsResponse: Decodable {
    let automations: [Automation]
    
    public struct Automation: Decodable {
        let automationId: String
        let automationName: String
        
        enum CodingKeys: String, CodingKey {
            case automationId = "automation_id"
            case automationName = "automation_name"
        }
    }
}
