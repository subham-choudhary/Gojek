//
//  ValidationError.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

struct ValidationError: Codable {
    let errors: [String]?
}
