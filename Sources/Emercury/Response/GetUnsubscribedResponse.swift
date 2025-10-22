public struct GetUnsubscribedResponse: Decodable {
    let unsubscribedEmails: [UnsubscribedEmail]
    
    public struct UnsubscribedEmail: Decodable {
        let email: String
    }
}
