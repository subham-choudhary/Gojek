//
//  Contact.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let profilePicURLString: String?
    let isFavorite: Bool?
    let urlString: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicURLString = "profile_pic"
        case isFavorite = "favorite"
        case urlString = "url"
    }
}
