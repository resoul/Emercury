public struct GetComplaintsResponse: Decodable {
    let complaintsEmails: [ComplaintsEmail]
    
    public struct ComplaintsEmail: Decodable {
        let email: String
    }
}
