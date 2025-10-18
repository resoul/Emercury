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
