public extension EmercuryRequest {
    static func getComplaints(taskId: Int) -> EmercuryRequest {
        return EmercuryRequest(method: "getComplaints", parameters: ["task_id": "\(taskId)"])
    }
}
