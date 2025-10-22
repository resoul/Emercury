public extension EmercuryRequest {
    static func getOpens(taskId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getOpens", parameters: ["task_id": "\(taskId)"])
    }
}
