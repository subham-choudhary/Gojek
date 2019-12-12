//
//  ErrorCodes.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
enum HTTPStatusCode: Int, Error {
    
    enum ResponseType {
        
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case undefined
    }

    case notFound = 404
    case validationError = 422
    case success = 200
    case success1 = 201
    case internalServerError = 500
    
    var responseType: ResponseType {
        
        switch self.rawValue {
            
        case 100..<200:
            return .informational
            
        case 200..<300:
            return .success
            
        case 300..<400:
            return .redirection
            
        case 400..<500:
            return .clientError
            
        case 500..<600:
            return .serverError
            
        default:
            return .undefined
            
        }
        
    }
    
}

extension HTTPURLResponse {
    
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
}
