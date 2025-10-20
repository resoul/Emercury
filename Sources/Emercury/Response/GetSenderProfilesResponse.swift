public struct GetSenderProfilesResponse: Decodable {
    let senderProfiles: [SenderProfile]
    
    public struct SenderProfile: Decodable {
        let senderProfileId: String
        let senderProfileName: String
        let fromAddressEmail: String
        let fromAddressStatus: String
        let replyToEmail: String
        let replyToStatus: String
        let footerOrganizationName: String
        let footerCity: String
        let footerAddress: String
        let domains: [Domain]
        
        enum CodingKeys: String, CodingKey {
            case senderProfileId = "sender_profile_id"
            case senderProfileName = "sender_profile_name"
            case fromAddressEmail = "from_address_email"
            case fromAddressStatus = "from_address_status"
            case replyToEmail = "reply_to_email"
            case replyToStatus = "reply_to_status"
            case footerOrganizationName = "footer_organization_name"
            case footerCity = "footer_city"
            case footerAddress = "footer_address"
            case domains = "domains"
        }
        
        public struct Domain: Decodable {
            let trackDomain: String
            let clickDomain: String
            let imageDomain: String
            
            enum CodingKeys: String, CodingKey {
                case trackDomain = "track_domain"
                case clickDomain = "click_domain"
                case imageDomain = "image_domain"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case senderProfiles = "sender_profiles"
    }
}
