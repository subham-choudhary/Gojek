//
//  DataTransferProtocols.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 13/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

protocol DataTransferDelegate: AnyObject {
    func didCreateContact(contact: Contact)
    func didUpdateContact(contactDetails: Contact)
    func didDeleteContact(id: Int)
}
