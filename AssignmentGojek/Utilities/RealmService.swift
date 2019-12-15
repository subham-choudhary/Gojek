//
//  RealmService.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 13/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    var realm: Realm? {
        do {
            return try Realm()
        } catch {
            return nil
        }
    }
    
    func createContactList(_ contacts: [Contact]) {
        
        do {
            try realm?.write {
            
                if let savedContacts = realm?.objects(Contact.self), savedContacts.count > 0 {
                    
                    var savedDict: [Int:Contact] = [:]
                    _ = Array(savedContacts).map {
                        savedDict[/$0.id.value] = $0
                    }
                    
                    _ = contacts.map {
                        if let savedContact = savedDict[/$0.id.value] {
                            savedDict.removeValue(forKey: /$0.id.value)
                            
                            if !(savedContact.firstName == $0.firstName && savedContact.lastName == $0.lastName && savedContact.isFavorite.value == $0.isFavorite.value) {
                                realm?.add($0, update: .all)
                            }
                        } else {
                            realm?.add($0)
                        }
                    }
                    savedDict.forEach({realm?.delete($0.value)})
                    
                } else {
                    realm?.add(contacts)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getAllContacts() -> [Contact]  {
        if let contacts = realm?.objects(Contact.self) {
            let contactsArray = Array(contacts).sorted()
            var favArr:[Contact] = []
            var norArr:[Contact] = []
            
            let _ = contactsArray.map {
                if $0.isFavorite.value == true {
                    favArr.append($0)
                } else {
                    norArr.append($0)
                }
            }
            return favArr + norArr
        }
        return []
    }
    
    func update(_ contact: Contact) {
        do {
            try realm?.write {
                realm?.add(contact, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    func addContact(_ contact: Contact) {
        do {
            try realm?.write {
                realm?.add(contact)
            }
        } catch {
            print(error)
        }
    }
    func deleteContact(_ contact: Contact) {
        do {
            try realm?.write {
                realm?.delete(contact)
            }
        } catch {
            print(error)
        }
    }

    
    func write(block: (Realm?)->Void) {
        do {
            try realm?.write {
                block(realm)
            }
        } catch {
            print(error)
        }
    }
    
    func getContactsWithId(id: Int) -> Contact? {
        return realm?.object(ofType: Contact.self, forPrimaryKey: id)
    }
}