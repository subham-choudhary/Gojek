//
//  CreateContactRequest.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

class CreateContactRequest : APIRequest {
    
    var method: RequestType {
        return .POST
    }
    var path: String = Endpoints.createContactList
    
    var urlParameters: [String : Any]?
    var postParameters: [String : Any]?
    
    init(postParameters: [String : Any]) {
        self.postParameters = postParameters
    }
}
