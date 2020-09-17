//
//  UIView+Bordor.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/13/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit


// This syntax reflects changes made to the Swift language as of Aug. '16
extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .Left: border.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.width-thickness, y: 0.0, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: 0.0, y: frame.height-thickness, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }

    
  
}
