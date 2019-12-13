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
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        clearSelection()
    }
    
    //MARK:- Actions
    
    @IBAction func createContact(_ sender: Any) {
        if let createVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.createEditVC) as? CreateEditViewController {
            createVC.delegate = self
            self.navigationController?.pushViewController(createVC, animated: true)
        }
    }
    
    //MARK:- Functions
    
    private func setupViewModel() {
        viewModel = ContactsListViewModel()
        viewModel?.onSuccess = { contacts in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let contacts = contacts  else { return }
                print(DataManager.contacts)
                DataManager.contacts = contacts
                print(DataManager.contacts)
                self.contactsList = DataManager.contacts
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
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    Utility.startSpinner(presentingView: self.view)
                    self.view.isUserInteractionEnabled = false
                }
            } else {
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
            contactDetailVC.delegate = self
            self.navigationController?.pushViewController(contactDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ContactsListViewController: DataTransferDelegate {
    func didDeleteContact(id: Int) {
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            if contactsList[selectedRow].id == id {
                contactsList.remove(at: selectedRow)
            }
        }
    }
    func didCreateContact(contact: Contact) {
        contactsList.insert(contact, at: 0)
    }
    func didUpdateContact(contactDetails: Contact) {
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            if contactsList[selectedRow].id == contactDetails.id {
                contactsList[selectedRow].firstName = contactDetails.firstName
                contactsList[selectedRow].lastName = contactDetails.lastName
                contactsList[selectedRow].isFavorite = contactDetails.isFavorite
            }
        }
    }
}
