import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public final class EmercuryClient {
    private let apiKey: String
    private let email: String
    private let baseURL: URL
    private let session: URLSessionProtocol
    
    public init(
        apiKey: String,
        email: String,
        baseURL: URL = URL(string: "https://api.emercury.net/api-json.php")!,
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.apiKey = apiKey
        self.email = email
        self.baseURL = baseURL
        self.session = session
    }
    
    public func execute<T: Decodable>(
        request: EmercuryRequest
    ) async throws -> EmercuryResponse<T> {
        let urlRequest = try buildURLRequest(for: request)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw EmercuryError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw EmercuryError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(EmercuryResponse<T>.self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(EmercuryErrorResponse.self, from: data) {
                throw EmercuryError.apiError(apiError)
            } else {
                throw EmercuryError.decodingFailed(error)
            }
        }
    }
    
    private func buildURLRequest(for request: EmercuryRequest) throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let jsonObject: [String: Any] = [
            "request": [
                "parameters": request.parameters,
                "method": request.method,
                "mail": email,
                "API_key": apiKey
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw EmercuryError.cannotEncodeRequestBody
        }
        
        let encodedString = "request=\(jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        urlRequest.httpBody = encodedString.data(using: .utf8)
        
        return urlRequest
    }
}

public extension EmercuryClient {
    func execute(request: EmercuryRequest) async throws {
        let _: EmercuryResponse<EmptyResponse> = try await execute(request: request)
    }
}
