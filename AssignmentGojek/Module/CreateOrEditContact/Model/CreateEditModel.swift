//
//  CreateEditModel.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import UIKit

struct createContactModel: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let favorite = true
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phoneNumber = "phone_number"
        case favorite
    }
}

