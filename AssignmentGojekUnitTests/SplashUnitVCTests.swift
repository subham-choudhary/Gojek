//
//  AssignmentGojekUnitTests.swift
//  AssignmentGojekUnitTests
//
//  Created by Subham Choudhary on 16/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import XCTest
@testable import AssignmentGojek

class SplashUnitTests: XCTestCase {

    var vc: SplashViewController?
    
    override func setUp() {
        
        RealmService.shared.shouldMock = true
        
        let storyboard = UIStoryboard(name: "Main",
            bundle: nil)
        vc = storyboard.instantiateViewController(identifier: StoryboardIdentifiers.splashVC) as? SplashViewController

        UIApplication.shared.windows.first!.rootViewController = vc
        let _ = vc!.view
        
    }

    override func tearDown() {
        vc = nil
    }

    func testViewAPISuccess() {
        vc?.viewModel = SplashViewModel_Mock()
        vc?.viewModel?.onSuccess = { contact in
            XCTAssertTrue(contact != nil)
        }
        vc?.viewModel?.getContactsList()
    }
    
    func testViewAPIFailure() {
        vc?.viewModel = SplashViewModel_Mock()
        vc?.viewModel?.onError = { error in
            XCTAssertTrue((error as! MyError).errorCode != nil)
        }
        vc?.viewModel?.shouldSuccess_Mock = false
        vc?.viewModel?.getContactsList()
    }
}
