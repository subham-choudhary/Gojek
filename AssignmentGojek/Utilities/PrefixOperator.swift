//
//  PrefixFunctions.swift
//  AssignmentGojek
//
//  Created by Subham Choudhary on 11/12/19.
//  Copyright © 2019 Subham Choudhary. All rights reserved.
//


import Foundation
import UIKit

prefix operator /
prefix func /(value : String?) -> String {
    return value ?? ""
}
prefix func /(value : Bool?) -> Bool {
    return value ?? false
}
prefix func /(value : Int?) -> Int {
    return value ?? 0
}
prefix func /(value : Float?) -> Float {
    return value ?? 0.0
}
prefix func /(value : NSString?) -> NSString {
    return value ?? ""
}
prefix func /(value : CGFloat?) -> CGFloat {
    return value ?? 0.0
}
prefix func /(value : Double?) -> Double {
    return value ?? 0.0
}
prefix func /(value : Array<Any>?) -> Array<Any> {
    return value ?? []
}
 
