//
//  UIViewConroller+Extension.swift
//  TheMovie
//
//  Created by A K on 6/23/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

extension UIViewController {

    var isPad: Bool {
        set {}
        
        get {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
}
