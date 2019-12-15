//
//  ContactsTableViewCellVM.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 13/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation


protocol ContactsTableViewCellProtocol{
    var onError : (Error) -> Void { get set}
    var onSuccessFetch : (Contact) -> Void { get set }
    var addRemoveLoader : (Bool) -> Void { get set}
    func getContactDetails(contactId: Int)
}

class ContactsTableViewCellVM : ContactsTableViewCellProtocol {

    //MARK:- Stored Properties
    
    var onSuccessFetch: (Contact) -> Void = {_ in }
    var onError: (Error) -> Void = {_ in}
    var addRemoveLoader: (Bool) -> Void = {_ in}
    
    //MARK:- Custom Functions
    
    func getContactDetails(contactId: Int) {
        let request = ModifyContactDetailsRequest(contactId: contactId, requestType: .GET)
        addRemoveLoader(true)
        APIClient().fetchData(apiRequest: request) {[weak self] (result : Result<Contact?,Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                if let model = model {
                    self.addRemoveLoader(false)
                    self.onSuccessFetch(model)
                }
            case .failure(let error):
                self.addRemoveLoader(false)
                self.onError(error)
            }
        }
    }

    
}


