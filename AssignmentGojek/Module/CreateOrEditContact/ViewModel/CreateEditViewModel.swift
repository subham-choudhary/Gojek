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
    var onSuccess : (ContactDetails?) -> Void { get set }
    var addRemoveLoader : (Bool) -> Void { get set}
    func createContactsWith(firstName: String?, lastName: String?, phoneNo: String?, email: String?)
    func updateContactsWith(id: Int, firstName: String?, lastName: String?, phoneNo: String?, email: String?, isFavourite: Bool?)
}

class CreateEditViewModel : CreateEditProtocol {
    var onError: (Error) -> Void = {_ in}
    var onSuccess: (ContactDetails?) -> Void = {_ in }
    var addRemoveLoader: (Bool) -> Void = {_ in}
    
    func createContactsWith(firstName: String?, lastName: String?, phoneNo: String?, email: String?) {
        addRemoveLoader(true)

        guard let postParameters = ContactDetails(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNo).dictionary else { return }

        
        let request = CreateContactRequest(postParameters: postParameters)
        APIClient().fetchData(apiRequest: request) {(result : Result<ContactDetails?,Error>) in
            self.addRemoveLoader(false)
            switch result {
            case .success(let model):
                self.onSuccess(model)
            case .failure(let error):
                self.onError(error)
            }
        }
    }
    
    func updateContactsWith(id: Int, firstName: String?, lastName: String?, phoneNo: String?, email: String?, isFavourite: Bool?) {
        addRemoveLoader(true)
        guard let postParameters = ContactDetails(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNo, isFavorite: isFavourite).dictionary else { return }
        
        let request = ModifyContactDetailsRequest(contactId: id, requestType: .PUT, postParameters: postParameters)
        APIClient().fetchData(apiRequest: request) {(result : Result<ContactDetails?,Error>) in
            self.addRemoveLoader(false)
            switch result {
            case .success(let model):
                self.onSuccess(model)
            case .failure(let error):
                self.onError(error)
            }
        }
    }
}


