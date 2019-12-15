//
//  SplashViewController.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 15/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var heading: UILabel!

    //MARK:- Stored Properties
    
    var viewModel: SplashProtocol?
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heading.startShimmeringAnimation()
        navigationController?.navigationBar.isHidden = true
        setupViewModel()
        viewModel?.getContactsList()
    }
    
    //MARK:- Custom Functions
    
    private func setupViewModel() {
        
        viewModel = SplashViewModel()
        viewModel?.onSuccess = { contacts in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let contacts = contacts  else { return }
                RealmService.shared.createContactList(contacts)
                
                if let contactListVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.contactListVC) as? ContactsListViewController {
                    contactListVC.contactsList = contacts
                    self.navigationController?.pushViewController(contactListVC, animated: true)
                    self.heading.stopShimmeringAnimation()
                }
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let contactListVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.contactListVC) as? ContactsListViewController {
                    self.navigationController?.pushViewController(contactListVC, animated: true)
                    self.heading.stopShimmeringAnimation()
                }
            }
        }
    }
}
