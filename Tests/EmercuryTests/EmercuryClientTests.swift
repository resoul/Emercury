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
        let expectedResponse = TestResponse(message: "success")
        let jsonData = try JSONEncoder().encode(expectedResponse)
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://api.emercury.net/api-json.php")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        let response: TestResponse = try await client.execute(request: request)
        
        XCTAssertEqual(response.message, "success")
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
            let _: TestResponse = try await client.execute(request: request)
            XCTFail("Expected error to be thrown")
        } catch let error as EmercuryError {
            if case .httpError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected httpError")
            }
        } catch {
            XCTFail("Unexpected error type")
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
    }
}
