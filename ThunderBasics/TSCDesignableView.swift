//
//  TSCLabel.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 19/01/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

import UIKit

/**
 A designable subclass of UILabel that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCLabel: UILabel {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.CGColor
        layer.borderWidth = borderWidth
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOpacity = shadowOpacity
    }
}

/**
 A designable subclass of UITextField that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCTextField: UITextField {
    
    /**
     The edge insets of the text field
    */
    @IBInspectable public var textInsets: CGSize = CGSizeZero
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.CGColor
        layer.borderWidth = borderWidth
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOpacity = shadowOpacity
    }
    
    init(insets: CGSize) {
        self.textInsets = insets
        super.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // placeholder position
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(textInsets.height, textInsets.width, textInsets.height, textInsets.width)))
    }
    
    // text position
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRectForBounds(UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(textInsets.height, textInsets.width, textInsets.height, textInsets.width)))
    }
}

/**
 A designable subclass of UIButton that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCButton: UIButton {
    
    /**
     The colour to highlight the text and border of the button with
     Uses the shared secondary color by default but may be overridden in it's IBDesignable property
     */
    @IBInspectable public var primaryColor: UIColor {
        didSet {
            updateButtonColours()
        }
    }
    
    /**
     The colour to highlight the text and border of the button with
     Uses blue color by default but may be overridden in it's IBDesignable property
     */
    @IBInspectable public var secondaryColor: UIColor {
        didSet {
            updateButtonColours()
        }
    }
    
    /**
     Switches the button to be of solid fill with rounded edges
     */
    @IBInspectable public var solidMode: Bool = false {
        didSet {
            updateButtonColours()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        primaryColor = UIColor.blueColor()
        secondaryColor = UIColor.whiteColor()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        primaryColor = UIColor.blueColor()
        secondaryColor = UIColor.whiteColor()
        super.init(frame: frame)
    }
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        updateButtonColours()
    }

    /**
     Handles complete setup of the button. This is it's own method so we can call the same setup in prepareforinterfacebuilder as well
     */
    private func updateButtonColours() {
        
        layer.borderWidth = borderWidth != 0 ? borderWidth : 2.0
        layer.cornerRadius = cornerRadius != 0 ? cornerRadius : 5.0
        layer.masksToBounds = false
        clipsToBounds = true
        
        //Default state
        layer.borderColor = borderColor != nil ? borderColor?.CGColor : primaryColor.CGColor
        
        if solidMode == true {
            
            setBackgroundImage(image(primaryColor), forState: .Normal)
            setBackgroundImage(image(secondaryColor), forState: .Highlighted)
            setTitleColor(secondaryColor, forState: .Normal)
            setTitleColor(primaryColor, forState: .Highlighted)
            
        } else {
            
            setTitleColor(primaryColor, forState: .Normal)
            setBackgroundImage(image(secondaryColor), forState: .Normal)
            
            //Touch down state
            setTitleColor(secondaryColor, forState: .Highlighted)
            setBackgroundImage(image(primaryColor), forState: .Highlighted)
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOpacity = shadowOpacity
        updateButtonColours()
    }
    
    /**
     Generates a 1px by 1px image of a given colour. Useful as UIButton only let's you set a background image for different states
     */
    func image(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return colorImage
        
    }
}


/**
 A designable subclass of UIView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCView: UIView {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.CGColor
        layer.borderWidth = borderWidth
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOpacity = shadowOpacity
    }
}

/**
 A designable subclass of UIImageView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCImageView: UIImageView {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.CGColor
        layer.borderWidth = borderWidth
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOpacity = shadowOpacity
    }
}

/**
 A designable subclass of UITextView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCTextView: UITextView {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.CGColor
        layer.borderWidth = borderWidth
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOpacity = shadowOpacity
    }
}

/**
 An inspectable extension of UIView that allows customisation of border color and width, as well as other properties
 */
public extension UIView {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = nil
    }
    
    /**
     The border color of the view
     */
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(CGColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    /**
     The border width of the label
     */
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /**
     The corner radius of the view
    */
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.CGColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(CGColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}
