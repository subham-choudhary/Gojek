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
    
    var contactDetails: ContactDetails? = nil
    
    //MARK:- Stored Properties
    
    private var viewModel: CreateEditProtocol?
    
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
    
    //MARK:- Action
    
    @IBAction func addProfileImage(_ sender: Any) {
        
    }
    
    @IBAction func didTapSave(_ sender: Any) {

        viewModel?.createContactsWith(firstName: textFields[0].text, lastName: textFields[1].text, phoneNo: textFields[2].text, email: textFields[3].text)
    }
    //MARK:- Functions
    
    private func setupUI() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardOnTouch))
        view.addGestureRecognizer(tap)
        registerKeyboardNotifications()
        profileImaveView.addCircularBorder()
        doneButton.isEnabled = false
        textFields[0].becomeFirstResponder()
        
        enableDoneIfDetailsValid()
    }
    
    private func enableDoneIfDetailsValid() {
        if /textFields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 && /textFields[1].text?.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false 
        }
        
    }
    
    private func setupViewModel() {
        viewModel = CreateEditViewModel()
        viewModel?.onSuccess = { contactDetails in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
//                self.updateUIWith(contactDetails: contactDetails)
            }
        }
        viewModel?.onError = { error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
//                self.navigationController?.popViewController(animated: true)
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.enableDoneIfDetailsValid()
        }
        return true
    }
}
