//
//  GetContactDetailsRequest.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

class ModifyContactDetailsRequest : APIRequest {
    
    var method: RequestType
    var path: String
    var urlParameters: [String : Any]?
    var postParameters: [String : Any]?
    
    init(contactId: Int, requestType: RequestType, postParameters: [String : Any]? = nil) {
        method = requestType
        path = Endpoints.getContactDetails.replacingOccurrences(of: "#", with: "\(contactId)")
        self.postParameters = postParameters
    }
}
