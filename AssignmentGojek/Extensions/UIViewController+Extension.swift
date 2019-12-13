//
//  UIViewController+Extension.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWith(message: String, action: (()->Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            action?()
        }))
        present(alert, animated: true)
    }
}
