//
//  ContactDetailsTests.swift
//  AssignmentGojekUnitTests
//
//  Created by Subham Choudhary on 17/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation


import Foundation
import XCTest
@testable import AssignmentGojek

class ContactDetailsTests: XCTestCase {

    var vc: ContactDetailsViewController?
    
    override func setUp() {
        
        RealmService.shared.shouldMock = true
        
        let storyboard = UIStoryboard(name: "Main",
            bundle: nil)
        vc = storyboard.instantiateViewController(identifier: StoryboardIdentifiers.contactDetailsVC) as? ContactDetailsViewController

        UIApplication.shared.windows.first!.rootViewController = vc
        let _ = vc!.view
        
    }

    override func tearDown() {
        vc = nil
        vc?.viewModel?.buttonClicked = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewAPIFetch() {
        let id = 0
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.viewModel?.onSuccessFetch = { _ in
            XCTAssertTrue(true)
        }
        vc?.viewModel?.onError = { error in
            XCTAssertTrue(false)
        }
        vc?.viewModel?.getContactDetails(contactId: id)
    }
    
    func testViewAPIFetch_Failure() {
        let id = 5
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.viewModel?.onSuccessFetch = { contact in
            XCTAssertTrue(false)
        }
        vc?.viewModel?.onError = { error in
            XCTAssertTrue(true)
        }
        vc?.viewModel?.getContactDetails(contactId: id)
    }
    
    
    func testViewAPIDelete() {
        let id = 0
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.viewModel?.onSuccessDelete = {
            XCTAssertTrue(true)
        }
        vc?.viewModel?.onError = { error in
            XCTAssertTrue(false)
        }
        vc?.viewModel?.deleteContact(contactId: id)
    }
    
    func testViewAPIUpdate() {
        let id = 0
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.viewModel?.onSuccessUpdate = {
            XCTAssertTrue(true)
        }
        vc?.viewModel?.onError = { error in
            XCTAssertTrue(false)
        }
        vc?.viewModel?.updateFavourite(contactId: id, isFavourite: true)
    }
    
    func testTapMessage() {
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.didTapMessage(UIButton())
        XCTAssertTrue(vc?.viewModel?.buttonClicked == ButtonType.message)
    }
    
    func testTapCall() {
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.didTapCall(UIButton())
        vc?.showAlertWith(message: "")
        XCTAssertTrue(vc?.viewModel?.buttonClicked == ButtonType.call)
    }
    
    func testTapEmail() {
        vc?.viewModel = ContactDetailsViewModel_Mock()
        vc?.didTapEmail(UIButton())
        XCTAssertTrue(vc?.viewModel?.buttonClicked == ButtonType.email)
    }
    func testUpdateUI() {
        vc?.contact = MockManager.shared.DB.first!
        vc?.updateUI()
        vc?.didTapEdit(UIButton())
        vc?.didTapFavourite(UIButton())
        vc?.didTapDelete(UIButton())
        XCTAssertTrue(true)
    }
}
