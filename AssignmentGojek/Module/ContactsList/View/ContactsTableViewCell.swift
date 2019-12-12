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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:- Functions
    
    func configureCell(_ contact: Contact) {
        fullNameLabel.text = /contact.firstName + " " + /contact.lastName
        interestedImageView.image = /contact.isFavorite ? UIImage(imageLiteralResourceName: "home_favourite") : nil
        profileImageView.downloadImage(urlString: /contact.profilePicURLString)
    }
}
