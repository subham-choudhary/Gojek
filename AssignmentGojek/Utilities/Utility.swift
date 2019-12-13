//
//  Utility.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import UIKit

class Utility: NSObject {
    
    private static let spinner = UIActivityIndicatorView()

    class func startSpinner(presentingView: UIView, color: UIColor = Color.greenColor) {
        DispatchQueue.main.async {
            spinner.hidesWhenStopped = true
            spinner.style = .gray
            spinner.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            spinner.frame = CGRect(x:presentingView.bounds.size.width / 2, y:presentingView.bounds.size.height / 2, width:40, height: 40)
            spinner.center = CGPoint(x: presentingView.bounds.size.width / 2, y: presentingView.bounds.size.height / 2)
            spinner.tag = 007
            spinner.startAnimating()
            spinner.color = color
            presentingView.addSubview(spinner)
        }
    }
    
    class func stopSpinner(presentingView: UIView){
        DispatchQueue.main.async {
            presentingView.viewWithTag(007)?.removeFromSuperview()
        }
    }
}
