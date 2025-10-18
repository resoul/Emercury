import Foundation

public struct EmercuryResponse<T: Decodable>: Decodable {
    public let value: T?
    
    enum CodingKeys: String, CodingKey {
        case automation, audiences
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if T.self == GetAudiencesResponse.self {
            print("debug: val is arr")
            let array = try? container.decodeIfPresent([T].self, forKey: .audiences) ?? []
            self.value = array as? T
        } else if T.self == StartAutomationResponse.self {
            print("debug: val is obj")
            value = try? container.decodeIfPresent(T.self, forKey: .automation)
        } else {
            self.value = nil
        }
    }
}
