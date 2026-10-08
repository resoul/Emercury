import XCTest
@testable import Emercury

final class ListHygieneHistoryTests: XCTestCase {
    func testRequestIncludesFiltersPaginationAndSort() {
        let request = EmercuryRequest.getListHygieneHistory(
            cleanListID: 42,
            startFrom: 10,
            amount: 20,
            sort: "date",
            sortDirection: "desc"
        )

        XCTAssertEqual(request.method, "getListHygieneHistory")
        XCTAssertEqual(request.parameters["method"], "getListHygieneHistory")
        XCTAssertEqual(request.parameters["clean_lists_id"], "42")
        XCTAssertEqual(request.parameters["start_from"], "10")
        XCTAssertEqual(request.parameters["amount"], "20")
        XCTAssertEqual(request.parameters["sort"], "date")
        XCTAssertEqual(request.parameters["sort_dir"], "desc")
    }

    func testRequestSupportsAmountWithoutOffset() {
        let request = EmercuryRequest.getListHygieneHistory(amount: 25)

        XCTAssertEqual(request.parameters["amount"], "25")
        XCTAssertNil(request.parameters["start_from"])
    }

    func testResponseDecodesHistoryAndEmptyResultMessage() throws {
        let historyJSON = """
        {
          "list_hygiene_total": "1",
          "list_hygiene": [{
            "clean_lists_id": "42",
            "billing_id": "0",
            "audience_name": "Main audience",
            "hygiene_type": "Clean + Verify",
            "size": "120",
            "cleaned": "118",
            "status": "Finished",
            "date": "10/08/2026"
          }]
        }
        """.data(using: .utf8)!

        let history = try JSONDecoder().decode(GetListHygieneHistoryResponse.self, from: historyJSON)
        XCTAssertEqual(history.listHygieneTotal, "1")
        XCTAssertEqual(history.listHygiene?.first?.cleanListsID, "42")
        XCTAssertEqual(history.listHygiene?.first?.audienceName, "Main audience")
        XCTAssertEqual(history.listHygiene?.first?.status, "Finished")

        let emptyJSON = #"{"message":"No reports found"}"#.data(using: .utf8)!
        let empty = try JSONDecoder().decode(GetListHygieneHistoryResponse.self, from: emptyJSON)
        XCTAssertNil(empty.listHygiene)
        XCTAssertEqual(empty.message, "No reports found")
    }
}
