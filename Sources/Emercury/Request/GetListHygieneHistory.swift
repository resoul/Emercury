public extension EmercuryRequest {
    static func getListHygieneHistory(
        cleanListID: Int? = nil,
        startFrom: Int? = nil,
        amount: Int? = nil,
        sort: String? = nil,
        sortDirection: String? = nil
    ) -> EmercuryRequest {
        var parameters: [String: String] = [:]

        if let cleanListID {
            parameters["clean_lists_id"] = "\(cleanListID)"
        }
        if let amount {
            parameters["amount"] = "\(amount)"
            if let startFrom {
                parameters["start_from"] = "\(startFrom)"
            }
        }
        if let sort, let sortDirection {
            parameters["sort"] = sort
            parameters["sort_dir"] = sortDirection
        }

        return EmercuryRequest(method: "getListHygieneHistory", parameters: parameters)
    }
}
