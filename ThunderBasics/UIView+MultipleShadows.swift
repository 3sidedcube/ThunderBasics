//
//  UIView+MultipleShadows.swift
//  ShadowView
//
//  Created by Simon Mitchell on 23/07/2020.
//  Copyright © 2020 3 Sided Cube. All rights reserved.
//

import UIKit

/// A simple subclass of `CALayer` so we can class-check within `MultipleShadowView`
internal class ShadowLayer: CALayer {
    
    init(
        shadowComponents: ShadowComponents,
        cornerRadius: CGFloat,
        cornerCurve: UIViewCornerCurve
    ) {
        super.init()
        self.shadow = shadow
        self.cornerRadius = cornerRadius
        self.viewCornerCurve = cornerCurve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UIView {
    
    /// Sets multiple shadows on the UIView instance, this is suitable if your corner radius or bounds are not changing.
    /// If your bounds or corner radius change, and you want your shadows to reflect these changes consider using or subclassing
    /// from `MultipleShadowView`
    /// - Parameters:
    ///   - shadows: The shadows to apply
    ///   - cornerRadius: The cornerRadius to give the shadows, if `nil` then this will be fetched from the view's own layer
    ///   - cornerCurve: The corner curve to give the shadows, if `nil` then this will be fetched from the view's own layer
    func setShadows(
        shadows: [ShadowComponents],
        cornerRadius: CGFloat? = nil,
        cornerCurve: UIViewCornerCurve? = nil
    ) {
        removeExistingShadowLayers()
        reconstructShadowLayers(
            from: shadows,
            withCornerRadius: cornerRadius ?? layer.cornerRadius,
            cornerCurve: cornerCurve ?? layer.viewCornerCurve
        )
    }

    private func removeExistingShadowLayers() {
        layer.sublayers?.filter({
            $0 is ShadowLayer
        }).forEach({
            $0.removeFromSuperlayer()
        })
    }
    
    private func reconstructShadowLayers(
        from shadows: [ShadowComponents],
        withCornerRadius cornerRadius: CGFloat,
        cornerCurve: UIViewCornerCurve
    ) {
        
        shadows.forEach { (shadow) in
            
            let shadowLayer = ShadowLayer(
                shadowComponents: shadow,
                cornerRadius: cornerRadius,
                cornerCurve: cornerCurve
            )
            shadowLayer.frame = bounds
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
