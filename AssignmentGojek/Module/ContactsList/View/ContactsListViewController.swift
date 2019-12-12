//
//  ViewController.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Stored Properties
    
    private var viewModel: ContactsListProtocol?
    private var contactsList: [Contact] = []
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel?.getContactsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getContactsList()
        clearSelection()
    }
    
    //MARK:- Functions
    
    private func setupViewModel() {
        viewModel = ContactsListViewModel()
        viewModel?.onSuccess = { contacts in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let contacts = contacts  else { return }
                self.contactsList = contacts
                self.tableView.reloadData()
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlertWith(message: error.localizedDescription)
            }
        }
        
        viewModel?.addRemoveLoader = { (shouldAddLoader) in
            if shouldAddLoader {
                DispatchQueue.main.async {
                    Utility.startSpinner(presentingView: self.view)
                    self.view.isUserInteractionEnabled = false

                }
            }else {
                DispatchQueue.main.async {
                    Utility.stopSpinner(presentingView: self.view)
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private func clearSelection() {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: false)
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as? ContactsTableViewCell else { return UITableViewCell() }
        cell.configureCell(contactsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let contactDetailVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.contactDetailsVC) as? ContactDetailsViewController {
            
            contactDetailVC.contactId = contactsList[indexPath.row].id
            self.navigationController?.pushViewController(contactDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
