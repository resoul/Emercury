import Foundation

public struct EmercuryRequest {
    let method: String
    let parameters: [String: String]
    
    public init(method: String, parameters: [String: String] = [:]) {
        var params = parameters
        params["method"] = method
        self.method = method
        self.parameters = params
    }
}

public extension EmercuryRequest {
    static func addSubscriber(
        email: String,
        listID: String,
        fields: [String: String] = [:]
    ) -> EmercuryRequest {
        var params = fields
        params["email"] = email
        params["list_id"] = listID
        return EmercuryRequest(method: "addSubscriber", parameters: params)
    }
    
    static func getSubscriber(email: String) -> EmercuryRequest {
        EmercuryRequest(method: "getSubscriber", parameters: ["email": email])
    }
    
    static func updateSubscriber(
        email: String,
        fields: [String: String]
    ) -> EmercuryRequest {
        var params = fields
        params["email"] = email
        return EmercuryRequest(method: "updateSubscriber", parameters: params)
    }
}
