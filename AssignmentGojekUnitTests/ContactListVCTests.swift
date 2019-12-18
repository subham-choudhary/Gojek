//
//  GetContactsUnitTests.swift
//  AssignmentGojekUnitTests
//
//  Created by Subham Choudhary on 16/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import XCTest
@testable import AssignmentGojek

class ContactListTests: XCTestCase {

    var vc: ContactsListViewController?
    
    override func setUp() {
        
        RealmService.shared.shouldMock = true
        
        let storyboard = UIStoryboard(name: "Main",
            bundle: nil)
        vc = storyboard.instantiateViewController(identifier: StoryboardIdentifiers.contactListVC) as? ContactsListViewController

        UIApplication.shared.windows.first!.rootViewController = vc
        let _ = vc!.view
        
    }

    override func tearDown() {
        vc = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewAPISuccess() {
        XCTAssertTrue(vc!.contactsList.count > 0)
    }

    func testTableViewCellConfigure() {
        let cell = vc?.tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as! ContactsTableViewCell
        cell.viewModel = ContactsTableViewCellVM_Mock()
        cell.configureCell(MockManager.shared.DB.first!)
        
        XCTAssertTrue(cell.contact?.edited == "false")
        XCTAssertTrue(cell.contact?.phoneNumber == "1234567890")
        XCTAssertTrue(cell.contact?.email == "mock@email.com")
    }
    
    func testDidSelectRowAtIndexPath() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        vc?.tableView(vc!.tableView, didSelectRowAt: indexPath)
        XCTAssertTrue(vc?.tableView.cellForRow(at: indexPath)?.isSelected == false)
        vc?.updateSearchResults(for: UISearchController())
    }
    
    func testTableViewCellConfigure_failure() {
        let cell = vc?.tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as! ContactsTableViewCell
        cell.viewModel = ContactsTableViewCellVM_Mock()
        cell.viewModel?.onError = { error in
            XCTAssertTrue((error as! MyError).errorCode == 0)
        }
        let contact = Contact(id: 4, firstName: nil, lastName: nil, email: nil, phoneNumber: nil, profilePicURLString: nil, isFavorite: nil, urlString: nil)
        cell.configureCell(contact)
    }
}
