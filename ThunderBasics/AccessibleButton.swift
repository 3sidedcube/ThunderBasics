//
//  AccessibleButton.swift
//  ThunderBasics-iOS
//
//  Created by Simon Mitchell on 05/09/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import UIKit

/// A subclass of `TSCButton` which enables automatic font adjustments, and allows for multi-line text
open class AccessibleButton: TSCButton {
    
    override init(frame: CGRect) {
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
    }
    
    override open var intrinsicContentSize: CGSize {
        return titleLabel?.intrinsicContentSize ?? super.intrinsicContentSize
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return titleLabel?.sizeThatFits(size) ?? super.sizeThatFits(size)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let titleLabel = titleLabel {
            titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        }
        super.layoutSubviews()
    }
}
