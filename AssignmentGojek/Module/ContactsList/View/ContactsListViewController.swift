//
//  ViewController.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit
import RealmSwift

class ContactsListViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Stored Properties

    var contactsList: [Contact] = []
    var filteredContactsList = [Contact]()
    var resultSearchController = UISearchController()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContactsFromLocal()
        clearSelection()
    }
    
    //MARK:- Triggers
    
    @IBAction func createContact(_ sender: Any) {
        if let createVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.createEditVC) as? CreateEditViewController {
            self.navigationController?.pushViewController(createVC, animated: true)
        }
    }
    
    //MARK:- Custom Functions
    
    private func getContactsFromLocal() {
        self.contactsList = RealmService.shared.getAllContacts()
        tableView.reloadData()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        tableView.reloadData()
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
        if  (resultSearchController.isActive) {
            return filteredContactsList.count
        } else {
            return contactsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as? ContactsTableViewCell else { return UITableViewCell() }
        
        if (resultSearchController.isActive) {
            cell.configureCell(filteredContactsList[indexPath.row])
        } else {
            cell.configureCell(contactsList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        var selectedContact: Contact?
        if resultSearchController.isActive {
            selectedContact = RealmService.shared.getContactsWithId(id: /filteredContactsList[indexPath.row].id.value)
            resultSearchController.isActive = false
        } else {
            selectedContact = RealmService.shared.getContactsWithId(id: /contactsList[indexPath.row].id.value)
        }
        if let selectedContact = selectedContact, let contactDetailVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.contactDetailsVC) as? ContactDetailsViewController,
            selectedContact.edited == "false" {
    
                contactDetailVC.contact = selectedContact
                self.navigationController?.pushViewController(contactDetailVC, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ContactsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredContactsList.removeAll(keepingCapacity: false)
        if let searchText = searchController.searchBar.text {
            if searchText.trimmingCharacters(in: .whitespaces).count == 0 {
                filteredContactsList = contactsList
            } else {
                filteredContactsList = contactsList.filter({ (contact) -> Bool in
                    let fullname = /contact.firstName + " " + /contact.lastName
                     return fullname.contains(searchText.lowercased())
                })
            }
            self.tableView.reloadData()
        }
    }
}
