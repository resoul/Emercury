import Foundation

public enum EmercuryError: Error, LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed(Error)
    case networkError(Error)
    case cannotEncodeRequestBody
    case apiError(EmercuryErrorResponse)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .apiError(let error):
            if let firstError = error.errors.first {
                if let message = firstError.campaign_id {
                    return message
                }
            }
            return "Unknown API error"
        case .cannotEncodeRequestBody:
            return "Failed to encode request body"
        }
    }
}

public struct EmercuryErrorResponse: Decodable {
    public let errors: [ErrorDetail]
    
    public struct ErrorDetail: Decodable {
        public let campaign_id: String?
        
        public init(campaign_id: String?) {
            self.campaign_id = campaign_id
        }
    }
    
    public init(errors: [ErrorDetail]) {
        self.errors = errors
    }
}
