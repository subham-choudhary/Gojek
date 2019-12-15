//
//  ContactsListViewModel.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

protocol SplashProtocol {
    var onError : (Error) -> Void { get set}
    var onSuccess : ([Contact]?) -> Void { get set }
    var addRemoveLoader : (Bool) -> Void { get set}
    func getContactsList()
}

class SplashViewModel : SplashProtocol {
    
    //MARK:- Stored Properties
    
    var onError: (Error) -> Void = {_ in}
    var onSuccess: ([Contact]?) -> Void = {_ in }
    var addRemoveLoader: (Bool) -> Void = {_ in}
    
    //MARK:- Custom Functions
    
    func getContactsList() {
        addRemoveLoader(true)
        let request = GetContactListRequest()
        APIClient().fetchData(apiRequest: request) {(result : Result<[Contact]?,Error>) in
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


