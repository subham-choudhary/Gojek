//
//  ContactDetailsViewController.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    

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
    var contactId: Int?
    private var contactDetails: ContactDetails? = nil
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        fetchContactDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContactDetails()
    }
    
    override func viewWillLayoutSubviews() {
        profileImageView.addCircularBorder()
    }
    //MARK:- Action
    
    @IBAction func didTapEdit(_ sender: Any) {
        if let createEditVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.createEditVC) as? CreateEditViewController {
            
            
            createEditVC.contactDetails = self.contactDetails
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
        guard let contactDetails = contactDetails else { return }
        viewModel?.updateFavourite(contactId: /self.contactId, isFavourite: !(/contactDetails.isFavorite))
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        if let id = contactId {
            viewModel?.deleteContact(contactId: id)
        }
    }
    
    //MARK:- Functions
    
    private func setupViewModel() {
        viewModel = ContactDetailsViewModel()
        viewModel?.onSuccess = { contactDetails in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.contactDetails = contactDetails
                self.updateUI()
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
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
    private func fetchContactDetails() {
        if let contactId = contactId {
            viewModel?.getContactDetails(contactId: contactId)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func updateUI() {
        guard let contactDetails = contactDetails else { return }
        
        profileImageView.downloadImage(urlString: /contactDetails.profilePicURLString)
        fullNameLabel.text = /contactDetails.firstName + " " + /contactDetails.lastName
        emailIdLabel.text = /contactDetails.email
        phoneNumberLabel.text = /contactDetails.phoneNumber
        favouriteButton.setImage(/contactDetails.isFavorite ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button"), for: .normal)
        
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
