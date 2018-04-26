//
//  Color+Hex.swift
//  LumoPostureV2.0
//
//  Created by Emil Selin on 4/7/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        self.init(red: CGFloat(hex >> 16 & 0xff)/255.0,
                  green: CGFloat(hex >> 8 & 0xff)/255.0,
                  blue: CGFloat(hex & 0xff)/255.0,
                  alpha: 1.0)
    }
}
