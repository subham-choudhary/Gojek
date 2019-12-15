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
        
        if let selectedContact = RealmService.shared.getContactsWithId(id: /contactsList[indexPath.row].id.value),
            selectedContact.edited == "false",
            let contactDetailVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.contactDetailsVC) as? ContactDetailsViewController {
    
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
