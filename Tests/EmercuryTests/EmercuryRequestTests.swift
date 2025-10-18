import XCTest
@testable import Emercury

final class EmercuryRequestTests: XCTestCase {
    func testRequestInitialization() {
        let request = EmercuryRequest(
            method: "testMethod",
            parameters: ["key1": "value1", "key2": "value2"]
        )
        
        XCTAssertEqual(request.method, "testMethod")
        XCTAssertEqual(request.parameters["method"], "testMethod")
        XCTAssertEqual(request.parameters["key1"], "value1")
        XCTAssertEqual(request.parameters["key2"], "value2")
    }
    
    func testRequestWithEmptyParameters() {
        let request = EmercuryRequest(method: "testMethod", parameters: [:])
        
        XCTAssertEqual(request.method, "testMethod")
        XCTAssertEqual(request.parameters["method"], "testMethod")
        XCTAssertEqual(request.parameters.count, 1)
    }
    
    func testGetAudiencesRequestBuilder() {
        let request = EmercuryRequest.getAudiences(includeSegments: true)
        
        XCTAssertEqual(request.method, "GetAudiences")
        XCTAssertEqual(request.parameters["include_segments"], "true")
    }
    
    func testGetSubscribersRequestBuilder() {
        let request = EmercuryRequest.getSubscribers(audienceId: 789)
        
        XCTAssertEqual(request.method, "GetSubscribers")
        XCTAssertEqual(request.parameters["audience_id"], "789")
    }
    
    func testStartAutomationRequestBuilder() {
        let request = EmercuryRequest.startAutomation(
            campaignID: "campaign123",
            email: "test@example.com"
        )
        
        XCTAssertEqual(request.method, "startAutomation")
        XCTAssertEqual(request.parameters["campaign_id"], "campaign123")
        XCTAssertEqual(request.parameters["email"], "test@example.com")
    }
}
