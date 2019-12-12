//
//  GetContactListRequest.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

class GetContactListRequest : APIRequest {
   
    var method: RequestType {
        return .GET
    }
    var path: String {
        return Endpoints.getContactList
    }
    
    var urlParameters: [String : Any]? {
        return nil
    }
    var postParameters: [String : Any]? {
        return nil
    }
}
