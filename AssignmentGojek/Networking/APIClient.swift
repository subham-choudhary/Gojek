//
//  APIClient.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

enum APIError : Error {
    case connectionError
    case statusCodeError
}

struct MyError: LocalizedError, Equatable {
    
    private var description: String!
    private var code : Int?
    
    
    init(description: String,code : Int?) {
        self.description = description
        self.code = code
    }
    
    var errorDescription: String? {
        return description
    }
}

class APIClient {
       
    func fetchData<T:Codable>(apiRequest:APIRequest,completion:@escaping (_ result:Result<T?,Error>) -> Void) {
        let request = apiRequest.request()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Connection Error")
                completion(.failure(error!))
                return
            }
            do {
                if let httpStatusCode =  response as? HTTPURLResponse {
                    print("Status code is \(httpStatusCode.statusCode)")
                    if let nsdata = data as? NSData {
                        if nsdata.length == 0 {
                            completion(.success(nil))
                            return
                        }
                    }
                    if httpStatusCode.status?.responseType == .success {
                        let model : T = try JSONDecoder().decode(T.self, from: data!)
                        completion(.success(model))
                        
                    } else if httpStatusCode.status == HTTPStatusCode.validationError {
                       
                    let model = try JSONDecoder().decode(ValidationError.self, from: data!)
                        var errorString = "422@"
                        if let errors = model.errors {
                            for err in errors {
                                errorString += err + "@"
                            }
                        }
                        let clientError = MyError(description: errorString , code: 422)
                       completion(.failure(clientError))
                        
                    } else {
                        completion(.failure(MyError(description: "Connection error! Please try again later.", code: nil)))
                    }
                }
                else {
                    print("Error in getting status code")
                }
            }
            catch(let parsingError){
                print("Error in parsing", parsingError)
                let clientError = NSError(domain: "Could not process your request.Please try again.", code: 111, userInfo: nil)
                completion(.failure(clientError))
            }
        }
        task.resume()
    }
}
