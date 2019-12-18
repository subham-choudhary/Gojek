//
//  RealmMockManager.swift
//  AssignmentGojekUnitTests
//
//  Created by Subham Choudhary on 16/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation

class MockManager {
    private init() {
        DB = mockContactList
    }
    static let shared = MockManager()
    let mockContactList = [
        Contact(id: 0, firstName: "aaa", lastName: "aaa", email: nil, phoneNumber: nil, profilePicURLString: "/images/missing.png", isFavorite: true, urlString: nil),
        Contact(id: 1, firstName: "bbb", lastName: "bbb", email: nil, phoneNumber: nil, profilePicURLString: "/images/missing.png", isFavorite: true, urlString: nil),
        Contact(id: 2, firstName: "ccc", lastName: "ccc", email: nil, phoneNumber: nil, profilePicURLString: "/images/missing.png", isFavorite: false, urlString: nil)]
    
    
    var DB:[Contact] = []
    
    func update(_ contact: Contact) {
        for index in 0..<DB.count {
            if DB[index].id.value == contact.id.value {
                DB[index] = contact
            }
        }
    }
    func delete(_ contact: Contact) {
        for index in 0..<DB.count {
            if DB[index].id.value == contact.id.value {
//                DB.remove(at: index)
                break
            }
        }
    }
    
    func getContactsWithId(id: Int) -> Contact?  {
        for contact in DB {
            if contact.id.value == id {
                return contact
            }
        }
        return nil
    }
}
