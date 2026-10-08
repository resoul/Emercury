public struct GetListHygieneHistoryResponse: Decodable {
    public let listHygieneTotal: String?
    public let listHygiene: [Record]?
    public let message: String?

    public struct Record: Decodable {
        public let cleanListsID: String
        public let billingID: String
        public let audienceName: String?
        public let hygieneType: String?
        public let size: String
        public let cleaned: String?
        public let status: String?
        public let date: String

        enum CodingKeys: String, CodingKey {
            case cleanListsID = "clean_lists_id"
            case billingID = "billing_id"
            case audienceName = "audience_name"
            case hygieneType = "hygiene_type"
            case size
            case cleaned
            case status
            case date
        }
    }

    enum CodingKeys: String, CodingKey {
        case listHygieneTotal = "list_hygiene_total"
        case listHygiene = "list_hygiene"
        case message
    }
}
