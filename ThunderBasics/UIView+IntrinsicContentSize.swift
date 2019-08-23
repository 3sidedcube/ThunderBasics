//
//  UIView+IntrinsicContentSize.swift
//  ThunderBasics-iOS
//
//  Created by Simon Mitchell on 22/08/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Returns the intrinsic content size an auto-layout based view will occupy when constrained
    /// to the given size and allowed to resize in the given axis.
    ///
    /// - Parameters:
    ///   - constrainedTo: The size the view is allowed to occupy.
    ///   - resizableAxis: The axis the view is allowed to resize in.
    /// - Returns: The size the view will occupy
    /// - Important: This will only behave nicely on views layed out using layout constraints as it essentialy adds a width or height constraint and calls `layoutSubviews()`. It must also therefore be run on the main thread!
    /// - Note: The returned size's width/height can be returned as smaller than the relative `constrainedSize` property if the content fits easily within the constrained width.
    func intrinsicContentSize(constrainedTo constrainedSize: CGSize, resizableAxis: NSLayoutConstraint.Axis = .vertical) -> CGSize {
        
        let size: CGSize
        
        // Keep track of these so we can re-set them after we're done calculating
        let translates = translatesAutoresizingMaskIntoConstraints
        translatesAutoresizingMaskIntoConstraints = false
        
        if resizableAxis == .vertical {
            
            let width = NSNumber(value: Float(constrainedSize.width))
            let temporaryWidthConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[view(width)]", options: [], metrics: ["width": width], views: ["view": self])
            addConstraints(temporaryWidthConstraint)
            
            setNeedsUpdateConstraints()
            setNeedsLayout()
            
            // Force the view to layout itself and any children
            updateConstraintsIfNeeded()
            layoutIfNeeded()
            
            size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .defaultLow)
            removeConstraints(temporaryWidthConstraint)
            
        } else {
            
            let height = NSNumber(value: Float(constrainedSize.height))
            let temporaryHeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[view(height)]", options: [], metrics: ["height": height], views: ["view": self])
            addConstraints(temporaryHeightConstraint)
            
            setNeedsUpdateConstraints()
            setNeedsLayout()
            
            // Force the view to layout itself and any children
            updateConstraintsIfNeeded()
            layoutIfNeeded()
            
            size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .fittingSizeLevel)
            removeConstraints(temporaryHeightConstraint)
        }
        
        translatesAutoresizingMaskIntoConstraints = translates
        
        return size
    }
}
