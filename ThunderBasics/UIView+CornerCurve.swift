//
//  UIView+CornerCurve.swift
//  ShadowView
//
//  Created by Simon Mitchell on 23/07/2020.
//  Copyright © 2020 3 Sided Cube. All rights reserved.
//

import UIKit

extension UIView {
    
    /// An enum representation of `CornerCurve` which allows backwards capability
    /// with iOS 12 without having to pepper `@available` everywhere
    enum CornerCurve {
        case circular
        case continuous
        
        @available(iOS 13, *)
        var layerCornerCurve: CALayerCornerCurve {
            switch self {
            case .circular:
                return .circular
            case .continuous:
                return .continuous
            }
        }
        
        @available(iOS 13, *)
        init(_ layerCornerCurve: CALayerCornerCurve) {
            switch layerCornerCurve {
            case .continuous:
                self = .continuous
            case .circular:
                self = .circular
            default:
                self = .continuous
            }
        }
    }
    
    /// Helper setter for setting corner curve on iOS 13 and above
    /// On earlier OS's this is simply ignored
    var cornerCurve: CornerCurve {
        set {
            layer.viewCornerCurve = newValue
        }
        get {
            return layer.viewCornerCurve
        }
    }
}

