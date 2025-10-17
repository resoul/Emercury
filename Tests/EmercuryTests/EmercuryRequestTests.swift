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
    
    func testGetSubscriberRequest() {
        let request = EmercuryRequest.getSubscriber(email: "test@example.com")
        
        XCTAssertEqual(request.method, "getSubscriber")
        XCTAssertEqual(request.parameters["email"], "test@example.com")
    }
    
    func testUpdateSubscriberRequest() {
        let request = EmercuryRequest.updateSubscriber(
            email: "test@example.com",
            fields: ["status": "active"]
        )
        
        XCTAssertEqual(request.method, "updateSubscriber")
        XCTAssertEqual(request.parameters["email"], "test@example.com")
        XCTAssertEqual(request.parameters["status"], "active")
    }
}
