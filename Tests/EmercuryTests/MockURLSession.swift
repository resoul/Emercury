import XCTest
@testable import Emercury
import Foundation

final class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var lastRequest: URLRequest?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request
        
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
