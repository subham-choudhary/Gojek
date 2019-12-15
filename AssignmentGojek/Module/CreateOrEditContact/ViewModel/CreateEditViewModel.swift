//
//  CreateEditViewModel.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import UIKit

protocol CreateEditProtocol {
    var onError : (Error) -> Void { get set}
    var onSuccess : (Contact?) -> Void { get set }
    var addRemoveLoader : (Bool) -> Void { get set}
    func createContactsWith(_ contacts: Contact)
    func updateContactsWith(_ contacts: Contact)
    func getStatusCodeIfInvalid(error: Error) -> String?
}

class CreateEditViewModel : CreateEditProtocol {
    
    //MARK:- Stored Properties
    
    weak var vc: CreateEditViewController?
    var onError: (Error) -> Void = {_ in}
    var onSuccess: (Contact?) -> Void = {_ in }
    var addRemoveLoader: (Bool) -> Void = {_ in}
    
    //MARK:- Custom Functions
    
    func createContactsWith(_ contacts: Contact) {
        addRemoveLoader(true)

        guard let postParameters = contacts.dictionary else { return }
        
        let request = CreateContactRequest(postParameters: postParameters)
        APIClient().fetchData(apiRequest: request) {(result : Result<Contact?,Error>) in
            self.addRemoveLoader(false)
            switch result {
            case .success(let model):
                self.onSuccess(model)
            case .failure(let error):
                self.onError(error)
            }
        }
    }
    func updateContactsWith(_ contacts: Contact) {
        addRemoveLoader(true)
        guard let postParameters = contacts.dictionary else { return }
        
        let request = ModifyContactDetailsRequest(contactId: /contacts.id.value, requestType: .PUT, postParameters: postParameters)
        APIClient().fetchData(apiRequest: request) {(result : Result<Contact?,Error>) in
            self.addRemoveLoader(false)
            switch result {
            case .success(let model):
                self.onSuccess(model)
            case .failure(let error):
                self.onError(error)
            }
        }
    }
    func getStatusCodeIfInvalid(error: Error) -> String? {
        let err = error.localizedDescription
        if err.count > 2 {
            let index = err.index(err.startIndex, offsetBy: 3)
            let statusCode = String(err[..<index])
            if statusCode == "422" {
                var errorCodes = err.split(separator: "@")
                errorCodes.removeFirst()
                let x = errorCodes.map { return String($0)}
                return x.joined(separator: ", ")
            }
        }
        return nil
    }
}


