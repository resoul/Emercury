public extension EmercuryRequest {
    static func getUnsubscribed(taskId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getUnsubscribed", parameters: ["task_id": "\(taskId)"])
    }
}
