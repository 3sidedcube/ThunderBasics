//
//  AccessibleButton.swift
//  ThunderBasics-iOS
//
//  Created by Simon Mitchell on 05/09/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import UIKit

/// Re-declares `UIButton`'s legacy edge inset properties without their deprecation attributes,
/// so they can be read without triggering deprecation warnings (which are treated as errors).
/// These properties still function at runtime as `TSCButton` does not use `UIButtonConfiguration`.
private protocol LegacyButtonEdgeInsets {
    var contentEdgeInsets: UIEdgeInsets { get }
    var imageEdgeInsets: UIEdgeInsets { get }
    var titleEdgeInsets: UIEdgeInsets { get }
}

extension UIButton: LegacyButtonEdgeInsets {}

/// A subclass of `TSCButton` which enables automatic font adjustments, and allows for multi-line text
open class AccessibleButton: TSCButton {

    private var legacyInsets: LegacyButtonEdgeInsets { self }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.textAlignment = .center
    }
    
    override open var intrinsicContentSize: CGSize {
        
        guard let titleLabel = titleLabel else {
            return super.intrinsicContentSize
        }
        
        let intrinsicSize = titleLabel.intrinsicContentSize
        
        return CGSize(width: intrinsicSize.width, height: intrinsicSize.height + legacyInsets.titleEdgeInsets.top + legacyInsets.titleEdgeInsets.bottom)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        guard let titleLabel = titleLabel else {
            return super.sizeThatFits(size)
        }
        
        let contentWidth = bounds.width - legacyInsets.contentEdgeInsets.left - legacyInsets.contentEdgeInsets.right
        let imageWidth = imageView?.bounds.width ?? 0 + legacyInsets.imageEdgeInsets.left + legacyInsets.imageEdgeInsets.right
        let titleMaxWidth = contentWidth - imageWidth - legacyInsets.titleEdgeInsets.left - legacyInsets.titleEdgeInsets.right

        let titleSize = titleLabel.sizeThatFits(CGSize(width: titleMaxWidth, height: size.height))

        return CGSize(width: titleSize.width, height: titleSize.height + legacyInsets.titleEdgeInsets.top + legacyInsets.titleEdgeInsets.bottom)
    }
    
    override open func layoutSubviews() {
        let contentWidth = bounds.width - legacyInsets.contentEdgeInsets.left - legacyInsets.contentEdgeInsets.right
        let imageWidth = imageView?.bounds.width ?? 0 + legacyInsets.imageEdgeInsets.left + legacyInsets.imageEdgeInsets.right
        let titleMaxWidth = contentWidth - imageWidth - legacyInsets.titleEdgeInsets.left - legacyInsets.titleEdgeInsets.right

        titleLabel?.preferredMaxLayoutWidth = titleMaxWidth
        super.layoutSubviews()
    }
}
