//
//  UIView+Extension.swift
//  Movie
//
//  Created by Andrii on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

extension UIView {
    
    class var reuseIdentifier: String {
        set {}
        
        get {
            return String(describing: type(of: self))
        }
    }
}
