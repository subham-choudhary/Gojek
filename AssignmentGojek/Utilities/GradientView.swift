//
//  GradientView.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 12/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func draw(_ rect: CGRect) {
        addGradientAndCircularBorder()
    }
    private func addGradientAndCircularBorder() {
        let gradient = CAGradientLayer()
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, UIColor(displayP3Red: 83/255, green: 227/255, blue: 194/225, alpha: 0.5).cgColor]
        gradient.locations = [0, 1]
        gradient.frame = bounds
        layer.mask = gradient
    }
}
