//
//  CreateEditTests.swift
//  AssignmentGojekUnitTests
//
//  Created by Subham Choudhary on 17/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import XCTest
@testable import AssignmentGojek

class CreateEditVCTests: XCTestCase {

    var vc: CreateEditViewController?
    
    override func setUp() {
        
        RealmService.shared.shouldMock = true
        
        let storyboard = UIStoryboard(name: "Main",
            bundle: nil)
        vc = storyboard.instantiateViewController(identifier: StoryboardIdentifiers.createEditVC) as? CreateEditViewController

        UIApplication.shared.windows.first!.rootViewController = vc
        let _ = vc!.view
        
    }

    override func tearDown() {
        vc = nil
    }

    
    func testCreateNewContact_If_contactVar_Empty() {
        vc?.contact = nil
        XCTAssertTrue(vc?.vcType == .some(.Create))
    }
    
    func testEditContact_If_contactVar_NotEmpty() {
        
        vc?.contact = MockManager.shared.DB.first!
        vc?.setupUI()
        XCTAssertTrue(vc?.vcType == .some(.Edit))
    }
    
    func testEditContact_MockAPI() {
        vc?.contact = MockManager.shared.DB.first!
        vc?.viewModel = CreateEditViewModel_Mock()
        vc?.textFields.first!.text?.isValidEmail()
        vc?.viewModel?.onSuccess = { contact in
            XCTAssertTrue(true)
        }
        vc?.didTapSave(UIButton())
    }
    
    func testCreateContact_MockAPI() {
        
        vc?.contact = nil
        vc?.viewModel = CreateEditViewModel_Mock()
        vc?.viewModel?.onSuccess = { contact in
            XCTAssertTrue(true)
        }
        vc?.didTapSave(UIButton())
    }
}
