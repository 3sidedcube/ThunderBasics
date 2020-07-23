//
//  CALayer+CornerCurve.swift
//  ShadowView
//
//  Created by Simon Mitchell on 23/07/2020.
//  Copyright © 2020 3 Sided Cube. All rights reserved.
//

import UIKit

extension CALayer {
    
    var viewCornerCurve: UIView.CornerCurve {
        set {
            if #available(iOS 13, *) {
                cornerCurve = newValue.layerCornerCurve
            }
        }
        get {
            if #available(iOS 13, *) {
                return UIView.CornerCurve(cornerCurve)
            }
            return .circular
        }
    }
}
