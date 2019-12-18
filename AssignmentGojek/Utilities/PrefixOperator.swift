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
