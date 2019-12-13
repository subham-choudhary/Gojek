//
//  ContactDetailsViewModel.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

protocol ContactDetailsProtocol {
    var onError : (Error) -> Void { get set}
    var onSuccessFetch : (Contact) -> Void { get set }
    var onSuccessDelete: () -> Void { get set }
    var onSuccessUpdate: () -> Void { get set }
    
    var addRemoveLoader : (Bool) -> Void { get set}
    func getContactDetails(contactId: Int)
    func deleteContact(contactId: Int)
    func updateFavourite(contactId: Int, isFavourite: Bool)
}

class ContactDetailsViewModel : ContactDetailsProtocol {

    var onError: (Error) -> Void = {_ in}
    var onSuccessFetch: (Contact) -> Void = {_ in }
    var onSuccessDelete: () -> Void = {}
    var onSuccessUpdate: () -> Void = {}
    
    var addRemoveLoader: (Bool) -> Void = {_ in}
    
    func getContactDetails(contactId: Int) {
        callApiWith(contactId: contactId, requestType: .GET)
    }
    
    func deleteContact(contactId: Int) {
         callApiWith(contactId: contactId, requestType: .DELETE)
    }
    
    func updateFavourite(contactId: Int, isFavourite: Bool) {
        callApiWith(contactId: contactId, requestType: .PUT, isFavourite: isFavourite)
    }
     
    func callApiWith(contactId: Int, requestType: RequestType, isFavourite: Bool? = nil) {
        addRemoveLoader(true)
        let request = ModifyContactDetailsRequest(contactId: contactId, requestType: requestType, postParameters: (isFavourite != nil ? ["favorite": isFavourite!] : nil))
        
        APIClient().fetchData(apiRequest: request) {(result : Result<Contact?,Error>) in
            self.addRemoveLoader(false)
            switch result {
            case .success(let model):
                switch requestType {
                case .GET: self.onSuccessFetch(model!)
                case .PUT: self.onSuccessUpdate()
                case .DELETE: self.onSuccessDelete()
                default: break
                }
            case .failure(let error):
                self.onError(error)
            }
        }
    }
    
}


