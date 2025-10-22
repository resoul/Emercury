public extension EmercuryRequest {
    static func getSoft(taskId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getSoft", parameters: ["task_id": "\(taskId)"])
    }
}
