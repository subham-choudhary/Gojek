//
//  ImageView+Extensions.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func downloadImage(urlString: String, completion: ((UIImage)->Void)? = nil, faliure:(()->Void)? = nil ) {
        let urlStr = Endpoints.baseURL + urlString

        guard let url = URL(string: urlStr) else {
            faliure?()
            return }
        
        image = #imageLiteral(resourceName: "placeholder_photo")
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = imageFromCache
            completion?(imageFromCache)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, respones, error) in
            if error != nil {
                faliure?()
                print(error!)
                return
            }
            guard let imageData = data,
                let self = self else { return }
            DispatchQueue.main.async {
                if let imageToCache = UIImage(data: imageData) {
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    self.image = imageToCache
                    completion?(imageToCache)
                }
               
            }
            
        }).resume()
    }
    
    func addCircularBorder() {
        let circularLayer = CAShapeLayer()
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        circularLayer.path = circlePath.cgPath
        circularLayer.fillColor = UIColor.clear.cgColor
        circularLayer.strokeColor = UIColor.white.cgColor
        circularLayer.lineWidth = 5.0
        circularLayer.strokeEnd = 1.0
        layer.addSublayer(circularLayer)
    }
}
