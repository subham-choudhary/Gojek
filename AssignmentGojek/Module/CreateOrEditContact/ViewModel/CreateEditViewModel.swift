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
    var onSuccess : (ContactDetails) -> Void { get set }
    var addRemoveLoader : (Bool) -> Void { get set}
    func createContactsWith(firstName: String?, lastName: String?, phoneNo: String?, email: String?)
}

class CreateEditViewModel : CreateEditProtocol {
    var onError: (Error) -> Void = {_ in}
    var onSuccess: (ContactDetails) -> Void = {_ in }
    var addRemoveLoader: (Bool) -> Void = {_ in}
    
    func createContactsWith(firstName: String?, lastName: String?, phoneNo: String?, email: String?) {
        addRemoveLoader(true)

        guard let postParameters = createContactModel(firstName: /firstName, lastName: /lastName, email: /phoneNo, phoneNumber: /phoneNo).dictionary else { return }
        
        let request = CreateContactRequest(postParameters: postParameters)
        APIClient().fetchData(apiRequest: request) {(result : Result<ContactDetails,Error>) in
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


