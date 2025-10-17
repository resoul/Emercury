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
    
    func testExecuteRequestSuccess() async throws {
        // Создаем ответ в формате, который ожидает EmercuryResponse
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
        
        let request = EmercuryRequest(method: "startAutomation", parameters: [:])
        let response: EmercuryResponse<StartAutomationResponse> = try await client.execute(request: request)
        
        XCTAssertNotNil(response.value)
        XCTAssertEqual(response.value?.message, "success")
    }
    
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
            let _: EmercuryResponse<StartAutomationResponse> = try await client.execute(request: request)
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
            let _: EmercuryResponse<StartAutomationResponse> = try await client.execute(request: request)
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
    
    func testStartAutomationWithAdditionalParams() {
        let request = EmercuryRequest.startAutomation(
            campaignID: "123",
            email: "user@example.com",
            additionalParams: ["custom_field": "custom_value"]
        )
        
        XCTAssertEqual(request.parameters["custom_field"], "custom_value")
    }
    
    func testAddSubscriberRequest() {
        let request = EmercuryRequest.addSubscriber(
            email: "user@example.com",
            listID: "456",
            fields: ["first_name": "John", "last_name": "Doe"]
        )
        
        XCTAssertEqual(request.method, "addSubscriber")
        XCTAssertEqual(request.parameters["email"], "user@example.com")
        XCTAssertEqual(request.parameters["list_id"], "456")
        XCTAssertEqual(request.parameters["first_name"], "John")
        XCTAssertEqual(request.parameters["last_name"], "Doe")
        XCTAssertEqual(request.parameters["method"], "addSubscriber")
    }
    
    func testGetSubscriberRequest() {
        let request = EmercuryRequest.getSubscriber(email: "test@example.com")
        
        XCTAssertEqual(request.method, "getSubscriber")
        XCTAssertEqual(request.parameters["email"], "test@example.com")
        XCTAssertEqual(request.parameters["method"], "getSubscriber")
    }
    
    func testUpdateSubscriberRequest() {
        let request = EmercuryRequest.updateSubscriber(
            email: "test@example.com",
            fields: ["status": "active"]
        )
        
        XCTAssertEqual(request.method, "updateSubscriber")
        XCTAssertEqual(request.parameters["email"], "test@example.com")
        XCTAssertEqual(request.parameters["status"], "active")
        XCTAssertEqual(request.parameters["method"], "updateSubscriber")
    }
    
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
        let _: EmercuryResponse<StartAutomationResponse> = try await client.execute(request: request)
        
        XCTAssertNotNil(mockSession.lastRequest)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
        XCTAssertEqual(mockSession.lastRequest?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertNotNil(mockSession.lastRequest?.httpBody)
        
        if let body = mockSession.lastRequest?.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            XCTAssertTrue(bodyString.hasPrefix("request="))
        }
    }
    
    func testExecuteVoidRequest() async throws {
        let responseDict: [String: Any] = [
            "automation": [:]
        ]
        
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
    
    func testInvalidResponseError() async {
        mockSession.data = Data()
        mockSession.response = URLResponse()
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        do {
            let _: EmercuryResponse<StartAutomationResponse> = try await client.execute(request: request)
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
}
