//
//  ContactDetailsViewController.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    //MARK:- Stored Properties
    
    private var viewModel: ContactDetailsProtocol?
    var contact: Contact? = nil
    private var isEdited: String? = ""
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel?.getContactDetails(contactId: /contact?.id.value)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        isEdited = contact?.edited
    }
    
    override func viewWillLayoutSubviews() {
        profileImageView.addCircularBorder()
    }
    
    //MARK:- Triggers
    
    @IBAction func didTapEdit(_ sender: Any) {
        if let createEditVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.createEditVC) as? CreateEditViewController {
            
            createEditVC.contact = self.contact
            self.navigationController?.pushViewController(createEditVC, animated: true)
        }
    }
    @IBAction func didTapMessage(_ sender: Any) {
        if let phoneNo = phoneNumberLabel.text, phoneNo != "" {
            let sms: String = "sms:+\(phoneNo)"
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapCall(_ sender: Any) {
        if let url = NSURL(string: "tel://\(/phoneNumberLabel.text)"), UIApplication.shared.canOpenURL(url as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    @IBAction func didTapEmail(_ sender: Any) {
        guard let email = emailIdLabel.text else { return }
        
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func didTapFavourite(_ sender: Any) {
        if let contact = self.contact {
            RealmService.shared.write { [weak self] (realm) in
                guard let self = self else { return }
                self.contact!.isFavorite.value = !contact.isFavorite.value!
            }
        }
        favouriteButton.setImage((/self.contact!.isFavorite.value) ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button"), for: .normal)
        viewModel?.updateFavourite(contactId: /self.contact!.id.value, isFavourite: (/self.contact!.isFavorite.value))
    }
    
    
    @IBAction func didTapDelete(_ sender: Any) {
        if let id = contact?.id.value {
            viewModel?.deleteContact(contactId: id)
            RealmService.shared.deleteContact(contact!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Custom Functions
    
    private func setupViewModel() {
        viewModel = ContactDetailsViewModel()
        
        viewModel?.onSuccessFetch = { _contact in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                _contact.edited = self.isEdited
                RealmService.shared.update(_contact)
                self.contact = _contact
                self.updateUI()
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlertWith(message: error.localizedDescription)
            }
        }
    }
    
    private func updateUI() {
        guard let contact = contact else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        profileImageView.downloadImage(urlString: /contact.profilePicURLString)
        fullNameLabel.text = /contact.firstName + " " + /contact.lastName
        emailIdLabel.text = /contact.email
        phoneNumberLabel.text = /contact.phoneNumber
        favouriteButton.setImage(/contact.isFavorite.value ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button"), for: .normal)
        
        if let phoneNo = phoneNumberLabel.text, phoneNo.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            messageButton.enableView()
            callButton.enableView()
        } else {
            messageButton.disableView()
            callButton.disableView()
        }
        
        if let email = emailIdLabel.text, email.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            emailButton.enableView()
        } else {
            emailButton.disableView()
        }
    }
}
