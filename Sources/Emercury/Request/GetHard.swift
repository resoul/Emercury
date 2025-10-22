public extension EmercuryRequest {
    static func getHard(taskId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getHard", parameters: ["task_id": "\(taskId)"])
    }
}
