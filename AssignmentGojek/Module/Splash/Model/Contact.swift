//
//  Contact.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Contact: Object, Codable, Comparable {
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        let lhsName = /lhs.firstName?.lowercased() + /lhs.lastName?.lowercased()
        let rhsName = /rhs.firstName?.lowercased() + /rhs.lastName?.lowercased()
        return lhsName < rhsName
    }
    
    
    dynamic var id = RealmOptional<Int>()
    dynamic var firstName: String? = ""
    dynamic var lastName: String? = ""
    dynamic var email: String? = ""
    dynamic var phoneNumber: String? = ""
    dynamic var profilePicURLString: String? = ""
    dynamic var isFavorite = RealmOptional<Bool>()
    dynamic var urlString: String? = ""
    dynamic var edited: String? = "true"
    
    enum CodingKeys: String, CodingKey {
        case id, email, edited
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case profilePicURLString = "profile_pic"
        case isFavorite = "favorite"
        case urlString = "url"
    }
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
    convenience init (id: Int? = nil , firstName: String? = "", lastName: String? = "", email: String? = "", phoneNumber: String? = "", profilePicURLString: String? = "" , isFavorite: Bool? = true, urlString: String? = "") {
        self.init()
        self.id.value = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.profilePicURLString = profilePicURLString
        self.isFavorite.value = isFavorite
        self.urlString = urlString
    }
}

