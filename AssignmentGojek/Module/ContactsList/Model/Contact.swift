//
//  Contact.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

struct Contact: Codable {
    
    var id: Int? = nil
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var profilePicURLString: String? = nil
    var isFavorite: Bool? = true
    var urlString: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case profilePicURLString = "profile_pic"
        case isFavorite = "favorite"
        case urlString = "url"
    }
}
