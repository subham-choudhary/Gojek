//
//  ContactsTableViewCell.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var interestedImageView: UIImageView!
    @IBOutlet weak var shimmerView: UIView!
    
    //MARK:- Stored Properties
    var viewModel: ContactsTableViewCellProtocol? = nil
    var contact: Contact? = nil
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shimmerView.stopShimmeringAnimation()
    }
    
    //MARK:- Custom Functions
    
    func configureCell(_ contact: Contact) {
        self.contact = contact
        fullNameLabel.text = /contact.firstName + " " + /contact.lastName
        interestedImageView.image = /contact.isFavorite.value ? UIImage(imageLiteralResourceName: "home_favourite") : nil
        profileImageView.downloadImage(urlString: /contact.profilePicURLString)
        
        if contact.edited == nil || contact.edited == "true" {
            viewModel?.getContactDetails(contactId: /contact.id.value)
            contentView.disableView(alpha: 0.7, withDuration: 0)
        } else {
            contentView.enableView(withDuration: 0)
        }
    }
    
    private func setupViewModel() {
        viewModel = ContactsTableViewCellVM()
        
        viewModel?.onSuccessFetch = {  contact in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, contact.id.value == self.contact?.id.value else {return}
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.contentView.enableView()
                }
                contact.edited = "false"
                RealmService.shared.update(contact)
            }
        }
        viewModel?.addRemoveLoader = { bool in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                if bool {
                    self.fullNameLabel.startShimmeringAnimation(animationSpeed: 1, repeatCount: MAXFLOAT)
                } else {
                    self.fullNameLabel.stopShimmeringAnimation()
                }
            }
        }
    }
}
