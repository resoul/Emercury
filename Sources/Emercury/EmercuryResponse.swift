import Foundation

public struct EmercuryResponse<T: Decodable>: Decodable {
    public let value: T?
    
    enum CodingKeys: String, CodingKey {
        case automation, audiences, list
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value =
            (try? container.decodeIfPresent(T.self, forKey: .automation)) ??
            (try? container.decodeIfPresent(T.self, forKey: .audiences)) ??
            (try? container.decodeIfPresent(T.self, forKey: .list))
    }
}
