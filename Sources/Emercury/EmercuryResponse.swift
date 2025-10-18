import Foundation

public struct EmercuryResponse<T: Decodable>: Decodable {
    public let value: T?
    
    enum CodingKeys: String, CodingKey {
        case automation, audiences
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let val = try? container.decodeIfPresent(T.self, forKey: .automation) {
            value = val
        } else if let val = try? container.decodeIfPresent(T.self, forKey: .audiences) {
            print("debug: val is obj")
            self.value = val
        } else if let array = try? container.decodeIfPresent([T].self, forKey: .audiences) {
            print("debug: val is arr")
            self.value = array as? T
        } else {
            self.value = nil
        }
    }
}
