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
    private var viewModel: CreateEditProtocol?
    var contactDetails: ContactDetails? = nil
    private var vcType: VCType = .Create
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVCType()
        setupViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Action
    
    @IBAction func addProfileImage(_ sender: Any) {
        
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        view.endEditing(true)
        switch vcType {
        case .Create: viewModel?.createContactsWith(firstName: textFields[0].text, lastName: textFields[1].text, phoneNo: textFields[2].text, email: textFields[3].text)
        
        case .Edit:
            guard let contactDetails = contactDetails else { return }
            viewModel?.updateContactsWith(id: /contactDetails.id ,firstName: textFields[0].text, lastName: textFields[1].text, phoneNo: textFields[2].text, email: textFields[3].text, isFavourite: contactDetails.isFavorite)
        }
        
    }
    //MARK:- Functions
    
    private func setupUI() {
        
        if let details = contactDetails {
            textFields[0].text = details.firstName
            textFields[1].text = details.lastName
            textFields[2].text = details.phoneNumber
            textFields[3].text = details.email
            if let url = details.profilePicURLString {
                profileImaveView.downloadImage(urlString: url)
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardOnTouch))
        view.addGestureRecognizer(tap)
        registerKeyboardNotifications()
        profileImaveView.addCircularBorder()
        textFields[0].becomeFirstResponder()
    }
    
    private func setupVCType() {
        vcType = contactDetails == nil ? .Create : .Edit
    }
    
    private func setupViewModel() {
        viewModel = CreateEditViewModel()
        viewModel?.onSuccess = { contactDetails in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlertWith(message: "Saved Successfully") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                var message = ""
                if let errorMessages = self.getStatusCodeIfInvalid(error: error) {
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
    
    private func getStatusCodeIfInvalid(error: Error) -> String? {
        let err = error.localizedDescription
        if err.count > 2 {
            let index = err.index(err.startIndex, offsetBy: 3)
            let statusCode = String(err[..<index])
            if statusCode == "422" {
                var errorCodes = err.split(separator: "@")
                errorCodes.removeFirst()
                let x = errorCodes.map { return String($0)}
                return x.joined(separator: ", ")
            }
        }
        return nil
    }
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
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
        if textField.tag < textFields.count - 1{
            textFields[textField.tag + 1].becomeFirstResponder()
        }
        return true
    }
}
