//
//  ContactDetailsViewModel.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import MessageUI

enum ButtonType {
    case call
    case message
    case email
}
protocol ContactDetailsProtocol {
    
    var onError : (Error) -> Void { get set}
    var onSuccessFetch : (Contact) -> Void { get set }
    var onSuccessDelete: () -> Void { get set }
    var onSuccessUpdate: () -> Void { get set }
    var addRemoveLoader: (Bool) -> Void { get set}
    var buttonClicked: ButtonType? { get set }
    
    func getContactDetails(contactId: Int)
    func deleteContact(contactId: Int)
    func updateFavourite(contactId: Int, isFavourite: Bool)
    func message(phoneNo: String?)
    func call(phoneNo: String?)
    func email(email: String?)
}

class ContactDetailsViewModel : ContactDetailsProtocol {

    //MARK:- Stored Properties
    
    var onError: (Error) -> Void = {_ in}
    var onSuccessFetch: (Contact) -> Void = {_ in }
    var onSuccessDelete: () -> Void = {}
    var onSuccessUpdate: () -> Void = {}
    var addRemoveLoader: (Bool) -> Void = {_ in}
    var buttonClicked: ButtonType? = nil
    
    //MARK:- Custom Functions
    
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
    
    func message(phoneNo: String?) {
        if let phoneNo = phoneNo, phoneNo != ""{
            let sms: String = "sms:+\(phoneNo)"
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
        }
    }
    
    func call(phoneNo: String?) {
        if let url = NSURL(string: "tel://\(/phoneNo)"), UIApplication.shared.canOpenURL(url as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    func email(email: String?) {
        guard let email = email else { return }
        
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

class ContactDetailsViewModel_Mock : ContactDetailsProtocol {
    
    //MARK:- Stored Properties
    
    var onError: (Error) -> Void = {_ in}
    var onSuccessFetch: (Contact) -> Void = {_ in }
    var onSuccessDelete: () -> Void = {}
    var onSuccessUpdate: () -> Void = {}
    var addRemoveLoader: (Bool) -> Void = {_ in}
    private let error = MyError(description: "Mock error", code: 0)
    var buttonClicked: ButtonType? = nil
    
    //MARK:- Custom Functions
    
    func getContactDetails(contactId: Int) {
        if contactId >= 0 && contactId <= 3 {

            onSuccessFetch(MockManager.shared.getContactsWithId(id: contactId)!)
        } else {
            onError(error)
        }
    }
    func deleteContact(contactId: Int) {
         if contactId >= 0 && contactId <= 3 {
             onSuccessDelete()
         } else {
             onError(error)
         }
    }
    func updateFavourite(contactId: Int, isFavourite: Bool) {
        if contactId >= 0 && contactId <= 3 {
            onSuccessUpdate()
        } else {
            onError(error)
        }
    }
    
    func message(phoneNo: String?) {
        buttonClicked = .message
    }
    
    func call(phoneNo: String?) {
        buttonClicked = .call
    }
    
    func email(email: String?) {
        buttonClicked = .email
    }
}


