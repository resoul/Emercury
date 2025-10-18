import XCTest
@testable import Emercury

final class EmercuryClientTests: XCTestCase {
    var mockSession: MockURLSession!
    var client: EmercuryClient!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        client = EmercuryClient(
            apiKey: "test_api_key",
            email: "test@example.com",
            session: mockSession
        )
    }
    
    override func tearDown() {
        mockSession = nil
        client = nil
        super.tearDown()
    }
    
    // MARK: - StartAutomation Tests
    
    func testStartAutomationSuccess() async throws {
        let responseDict: [String: Any] = [
            "automation": [
                "message": "Automation started successfully"
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseDict, options: [])
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest.startAutomation(
            campaignID: "123",
            email: "user@example.com"
        )
        let response: StartAutomationResponse = try await client.execute(request: request)
        
        XCTAssertEqual(response.automation.message, "Automation started successfully")
    }
    
    func testStartAutomationRequest() {
        let request = EmercuryRequest.startAutomation(
            campaignID: "123",
            email: "user@example.com"
        )
        
        XCTAssertEqual(request.method, "startAutomation")
        XCTAssertEqual(request.parameters["campaign_id"], "123")
        XCTAssertEqual(request.parameters["email"], "user@example.com")
        XCTAssertEqual(request.parameters["method"], "startAutomation")
    }
    
    // MARK: - GetAudiences Tests
    
    func testGetAudiencesSuccess() async throws {
        let responseDict: [String: Any] = [
            "audiences": [
                [
                    "id": "1",
                    "name": "Test Audience",
                    "size": "100",
                    "subscribers_count": "95",
                    "unsubscribed": "5",
                    "status": "active",
                    "is_segment": "0"
                ],
                [
                    "id": "2",
                    "name": "VIP List",
                    "size": "50",
                    "subscribers_count": "48",
                    "unsubscribed": "2",
                    "status": "active",
                    "is_segment": "1"
                ]
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseDict, options: [])
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest.getAudiences(includeSegments: true)
        let response: GetAudiencesResponse = try await client.execute(request: request)
        
        XCTAssertEqual(response.audiences.count, 2)
        XCTAssertEqual(response.audiences[0].id, "1")
        XCTAssertEqual(response.audiences[0].name, "Test Audience")
        XCTAssertEqual(response.audiences[0].size, "100")
        XCTAssertEqual(response.audiences[0].subscribersCount, "95")
        XCTAssertEqual(response.audiences[1].isSegment, "1")
    }
    
    func testGetAudiencesRequest() {
        let request = EmercuryRequest.getAudiences(includeSegments: true)
        
        XCTAssertEqual(request.method, "GetAudiences")
        XCTAssertEqual(request.parameters["include_segments"], "true")
        XCTAssertEqual(request.parameters["method"], "GetAudiences")
    }
    
    func testGetAudiencesRequestWithoutSegments() {
        let request = EmercuryRequest.getAudiences(includeSegments: false)
        
        XCTAssertEqual(request.parameters["include_segments"], "false")
    }
    
    // MARK: - GetSubscribers Tests
    
    func testGetSubscribersSuccess() async throws {
        let responseDict: [String: Any] = [
            "subscribers": [
                [
                    "email": "user1@example.com",
                    "audience_name": "Test Audience"
                ],
                [
                    "email": "user2@example.com",
                    "audience_name": "Test Audience"
                ]
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseDict, options: [])
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest.getSubscribers(audienceId: 123)
        let response: GetSubscribersResponse = try await client.execute(request: request)
        
        XCTAssertEqual(response.subscribers.count, 2)
        XCTAssertEqual(response.subscribers[0].email, "user1@example.com")
        XCTAssertEqual(response.subscribers[0].audienceName, "Test Audience")
        XCTAssertEqual(response.subscribers[1].email, "user2@example.com")
    }
    
    func testGetSubscribersRequest() {
        let request = EmercuryRequest.getSubscribers(audienceId: 456)
        
        XCTAssertEqual(request.method, "GetSubscribers")
        XCTAssertEqual(request.parameters["audience_id"], "456")
        XCTAssertEqual(request.parameters["method"], "GetSubscribers")
    }
    
    // MARK: - Error Handling Tests
    
    func testExecuteRequestHTTPError() async {
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: StartAutomationResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .httpError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected httpError, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testExecuteRequestAPIError() async {
        let errorDict: [String: Any] = [
            "errors": [
                ["campaign_id": "Invalid campaign ID"]
            ]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: errorDict, options: [])
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: StartAutomationResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .apiError(let apiError) = error {
                XCTAssertEqual(apiError.errors.first?.campaign_id, "Invalid campaign ID")
            } else {
                XCTFail("Expected apiError, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testInvalidResponseError() async {
        mockSession.data = Data()
        mockSession.response = URLResponse()
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: StartAutomationResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .invalidResponse = error {
                // Success
            } else {
                XCTFail("Expected invalidResponse error, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testDecodingFailedError() async {
        let invalidJson = "invalid json".data(using: .utf8)!
        
        mockSession.data = invalidJson
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: StartAutomationResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .decodingFailed = error {
                // Success
            } else {
                XCTFail("Expected decodingFailed error, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - Request Building Tests
    
    func testBuildURLRequestFormat() async throws {
        let responseDict: [String: Any] = [
            "automation": [
                "message": "success"
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseDict, options: [])
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: ["param1": "value1"])
        let _: StartAutomationResponse = try await client.execute(request: request)
        
        XCTAssertNotNil(mockSession.lastRequest)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
        XCTAssertEqual(mockSession.lastRequest?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertNotNil(mockSession.lastRequest?.httpBody)
        
        if let body = mockSession.lastRequest?.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            XCTAssertTrue(bodyString.hasPrefix("request="))
        }
    }
    
    // MARK: - Void Response Tests
    
    func testExecuteVoidRequest() async throws {
        let responseDict: [String: Any] = [:]
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseDict, options: [])
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        // Не должно бросить ошибку
        try await client.execute(request: request)
    }
    
    // MARK: - HTTP Status Code Tests
    
    func testHTTPStatusCode500() async {
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: StartAutomationResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .httpError(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected httpError, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testHTTPStatusCode401() async {
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: StartAutomationResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .httpError(let statusCode) = error {
                XCTAssertEqual(statusCode, 401)
            } else {
                XCTFail("Expected httpError, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
