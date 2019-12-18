//
//  CreateEditViewController.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit

class CreateEditViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var profileImaveView: UIImageView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    //MARK:- Stored Properties
    enum VCType {
        case Create
        case Edit
    }
    var viewModel: CreateEditProtocol?
    var contact: Contact? = nil
    var vcType: VCType = .Create
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Triggers
    
    @IBAction func addProfileImage(_ sender: Any) {
        
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        view.endEditing(true)
        switch vcType {
        case .Create:
            let newContact = Contact(id: nil, firstName: textFields[0].text, lastName: textFields[1].text, email: textFields[3].text, phoneNumber: textFields[2].text, profilePicURLString: nil, isFavorite: true, urlString: nil)
            viewModel?.createContactsWith(newContact)
            
        
        case .Edit:
            guard let contact = self.contact else { return }
            let editedContact = Contact(id: contact.id.value, firstName: textFields[0].text, lastName: textFields[1].text, email: textFields[3].text, phoneNumber: textFields[2].text, profilePicURLString: contact.profilePicURLString, isFavorite: contact.isFavorite.value, urlString: contact.urlString)
            viewModel?.updateContactsWith(editedContact)
        }
    }
    //MARK:- Custom Functions
    
    func setupUI() {
        if let contact = contact {
            textFields[0].text = contact.firstName
            textFields[1].text = contact.lastName
            textFields[2].text = contact.phoneNumber
            textFields[3].text = contact.email
            if let url = contact.profilePicURLString {
                profileImaveView.downloadImage(urlString: url)
            }
            vcType = .Edit
        } else {
            vcType = .Create
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardOnTouch))
        view.addGestureRecognizer(tap)
        registerKeyboardNotifications()
        profileImaveView.addCircularBorder()
        textFields[0].becomeFirstResponder()
    }
    
    private func setupViewModel() {
        viewModel = CreateEditViewModel()
        viewModel?.onSuccess = { _contact in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let _contact = _contact else { return }
                switch self.vcType {
                case .Create:
                    RealmService.shared.addContact(_contact)
                    self.showAlertWith(message: "Contact Saved") {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .Edit:
                    RealmService.shared.write { [weak self] in
                    guard let self = self else { return }
                        self.contact?.firstName = _contact.firstName
                        self.contact?.lastName = _contact.lastName
                        self.contact?.phoneNumber = _contact.phoneNumber
                        self.contact?.email = _contact.email
                        self.contact?.edited = "true"
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                var message = ""
                if let errorMessages = self.viewModel?.getStatusCodeIfInvalid(error: error) {
                    message = errorMessages
                } else {
                    message = error.localizedDescription
                }
                self.showAlertWith(message: message)
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
    
    @objc private func dismissKeyboardOnTouch() {
        self.view.endEditing(true)
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

//MARK:- UITextFieldDelegate

extension CreateEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == textFields.count - 1 {
            textField.resignFirstResponder()
            return true
        }
        if textField.tag < textFields.count - 1 {
            textFields[textField.tag + 1].becomeFirstResponder()
        }
        return true
    }
}
