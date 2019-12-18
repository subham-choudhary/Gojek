//
//  APIRequest.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
protocol APIRequest {
    var method : RequestType { get }
    var path : String { get }
    var urlParameters : [String : Any]? { get }
    var postParameters : [String : Any]? { get }
}

enum RequestType : String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension APIRequest {

    func request() -> URLRequest {

        let baseUrl = Endpoints.baseURL
        
        guard let apiURL = URL(string: baseUrl) else {
            fatalError("Unable to create Base URL")
        }
        guard var components = URLComponents(url: apiURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
    
        if urlParameters != nil {
            
            components.queryItems = urlParameters!.map {
                URLQueryItem(name: String($0), value: ($1 as? String) ?? "\($1)")
        
            }
        }
    
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if postParameters != nil {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postParameters!, options: [])
            }
            catch {
                print("error")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}


