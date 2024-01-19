//
//  UIColor+CustomColor.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import UIKit

extension UIColor {
    static let customColor = CustomColors()
    
    struct CustomColors {
        let pointColor = UIColor(named: "PointColor") ?? .white
    }
}
