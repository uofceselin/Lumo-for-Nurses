//
//  Color+Lerp.swift
//  LumoPostureV2.0
//
//  Created by Emil Selin on 4/8/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

extension UIColor {
    static func lerp(colorA: UIColor, colorB: UIColor, colorC: UIColor, t: CGFloat) -> UIColor {
        let compA = t < 0.5 ? colorA.cgColor.components! : colorB.cgColor.components!
        let compB = t < 0.5 ? colorB.cgColor.components! : colorC.cgColor.components!
        return UIColor(red: compA[0] + (compB[0] - compA[0]) * (t*2 - 1),
                       green: compA[1] + (compB[1] - compA[1]) * (t*2 - 1),
                       blue: compA[2] + (compB[2] - compA[2]) * (t*2 - 1),
                       alpha: 1.0)
    }
}
