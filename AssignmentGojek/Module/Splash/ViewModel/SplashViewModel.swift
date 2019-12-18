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
    var shouldSuccess_Mock: Bool { get set }
    func getContactsList()
}

class SplashViewModel : SplashProtocol {
    
    //MARK:- Stored Properties

    var onError: (Error) -> Void = {_ in}
    var onSuccess: ([Contact]?) -> Void = {_ in }
    var addRemoveLoader: (Bool) -> Void = {_ in}
    var shouldSuccess_Mock: Bool = true
    
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

class SplashViewModel_Mock : SplashProtocol {
    
    //MARK:- Stored Properties
    
    var onError: (Error) -> Void = {_ in}
    var onSuccess: ([Contact]?) -> Void = {_ in }
    var addRemoveLoader: (Bool) -> Void = {_ in}
    var shouldSuccess_Mock: Bool = true
    
    //MARK:- Custom Functions
    
    func getContactsList() {
        if shouldSuccess_Mock {
            self.onSuccess(MockManager.shared.mockContactList)
        } else {
            self.onError(MyError(description: "MockFaliure", code:0))
        }
    }
}


