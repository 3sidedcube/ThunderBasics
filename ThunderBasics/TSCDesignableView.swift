//
//  TSCLabel.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 19/01/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

#if os(iOS)
/**
 A designable subclass of UILabel that allows customisation of border color and width, as well as other properties
 */

@IBDesignable public class TSCLabel: UILabel {
    
    /**
     The edge insets of the label
     */
    @IBInspectable public var textInsets: CGSize = CGSizeZero
    
    private var edgeInsets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: textInsets.height, left: textInsets.width, bottom: textInsets.height, right: textInsets.width)
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
    }
    
    override public func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        
        var adjSize = super.sizeThatFits(size)
        adjSize.width += textInsets.width * 2
        adjSize.height += textInsets.height * 2
        
        return adjSize
    }
    
    override public func intrinsicContentSize() -> CGSize {
        
        var contentSize = super.intrinsicContentSize()
        contentSize.width += textInsets.width * 2
        contentSize.height += textInsets.height * 2
        
        return contentSize
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
}
    
public extension TSCTextField {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()

        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
    }
    
    public convenience init(insets: CGSize) {
        self.init(frame: CGRectZero)
        self.textInsets = insets
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
#elseif os(OSX)
@IBDesignable public class TSCTextField: NSTextField {
    /**
     The edge insets of the text field
     */
    @IBInspectable public var textInsets: CGSize = CGSizeZero
}
    
public extension TSCTextField {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        if let _borderColor = borderColor {
            layer?.borderColor = _borderColor.CGColor
        }
        layer?.borderWidth = borderWidth
    }
}
#endif

#if os(iOS)
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
    @IBInspectable public var solidMode: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        
        primaryColor = UIColor.blueColor()
        secondaryColor = UIColor.whiteColor()
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        updateButtonColours()
    }
    
    /**
     Handles complete setup of the button. This is it's own method so we can call the same setup in prepareforinterfacebuilder as well
     */
    private func updateButtonColours() {
        
        layer.borderWidth = 2.0
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        clipsToBounds = true
        
        //Default state
        layer.borderColor = primaryColor.CGColor
        
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
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
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
    
#elseif os(OSX)
    
public class TSCButtonCell: NSButtonCell {
    
    /**
     The edge insets of the button
     */
    public var edgeInsets: NSSize = NSMakeSize(0, 0)
    
    public override func drawingRectForBounds(theRect: NSRect) -> NSRect {
        
        let newRect = NSInsetRect(theRect, edgeInsets.width/2, edgeInsets.height/2)
        return super.drawingRectForBounds(newRect)
    }
}
    
/**
 A designable subclass of NSButton that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCButton: NSButton {
    
    /**
     The edge insets of the button
     */
    @IBInspectable public var edgeInsets: NSSize = NSMakeSize(0, 0) {
        didSet {
            
            if let _tscCell = cell as? TSCButtonCell {
                _tscCell.edgeInsets = edgeInsets
            }
            
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var alignment: NSTextAlignment {
        didSet {
            updateTitle(title)
        }
    }
    
    override public var font: NSFont? {
        didSet {
            updateTitle(title)
        }
    }
    
    override public var title: String {
        set {
            super.title = newValue
            updateTitle(newValue)
        }
        get {
            return attributedTitle.string
        }
    }
    
    private func updateTitle(newTitle: String) {
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = alignment

        let _font = font != nil ? font! : NSFont.systemFontOfSize(NSFont.systemFontSize())
        
        let attributes = [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor, NSFontAttributeName: _font, NSParagraphStyleAttributeName: paragraphStyle]
        attributedTitle = NSAttributedString(string: newTitle, attributes: attributes)
    }
    
    /**
     The colour to highlight the text and border of the button with
     Uses the shared secondary color by default but may be overridden in it's IBDesignable property
     */
    @IBInspectable public var primaryColor: NSColor {
        didSet {
            updateButtonColours()
        }
    }
    
    /**
     The colour to highlight the text and border of the button with
     Uses blue color by default but may be overridden in it's IBDesignable property
     */
    @IBInspectable public var secondaryColor: NSColor {
        didSet {
            updateButtonColours()
        }
    }
    
    /**
     The border width of the button
     */
    @IBInspectable override public var borderWidth: CGFloat {
        get {
            guard let _layer = layer else { return 0.0 }
            return _layer.borderWidth
        }
        set {
            wantsLayer = true
            layer?.borderWidth = newValue
        }
    }
    
    /**
     The corner radius of the button
     */
    @IBInspectable override public var cornerRadius: CGFloat {
        get {
            guard let _layer = layer else { return 0.0 }
            return _layer.cornerRadius
        }
        set {
            wantsLayer = true
            layer?.cornerRadius = newValue
            layer?.masksToBounds = newValue > 0
        }
    }
    
    /**
     Switches the button to be of solid fill with rounded edges
     */
    @IBInspectable public var solidMode: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        
        primaryColor = NSColor.blueColor()
        secondaryColor = NSColor.whiteColor()
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        updateButtonColours()
        updateTitle(title)
    }
    
    /**
     Handles complete setup of the button. This is it's own method so we can call the same setup in prepareforinterfacebuilder as well
     */
    private func updateButtonColours() {
        
        layer?.borderWidth = borderWidth
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = false
        layer?.masksToBounds = true
        
        //Default state
        layer?.borderColor = primaryColor.CGColor
        
        if solidMode == true {
            
            layer?.backgroundColor = primaryColor.CGColor
        } else {
            
            layer?.backgroundColor = secondaryColor.CGColor
        }
        
        attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor])
    }
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        if let _borderColor = borderColor {
            layer?.borderColor = _borderColor.CGColor
        }
        updateButtonColours()
    }
    
    public override var intrinsicContentSize: NSSize {
        get {
            
            if let _ = cell as? TSCButtonCell {
                return super.intrinsicContentSize
            } else {
                let size = super.intrinsicContentSize
                return NSMakeSize(size.width + edgeInsets.width, size.height + edgeInsets.height)
            }
        }
    }
}
    
public class TSCPopUpButtonCell: NSPopUpButtonCell {
    
    /**
     The edge insets of the button
     */
    public var edgeInsets: NSSize = NSMakeSize(0, 0)
    
    public override func drawingRectForBounds(theRect: NSRect) -> NSRect {
        
        let newRect = NSInsetRect(theRect, edgeInsets.width/2, edgeInsets.height/2)
        return super.drawingRectForBounds(newRect)
    }
    
    public override func titleRectForBounds(cellFrame: NSRect) -> NSRect {
        
        let newRect = NSInsetRect(cellFrame, edgeInsets.width/2, edgeInsets.height/2)
        return super.titleRectForBounds(newRect)
    }
    
    public override func imageRectForBounds(theRect: NSRect) -> NSRect {
        
        let newRect = NSInsetRect(theRect, edgeInsets.width/2, edgeInsets.height/2)
        return super.imageRectForBounds(newRect)
    }
}
    
/**
 A designable subclass of NSPopUpButton that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCPopUpButton: NSPopUpButton {
    
    /**
     The edge insets of the button
     */
    @IBInspectable public var edgeInsets: NSSize = NSMakeSize(0, 0) {
        didSet {
            
            if let _tscCell = cell as? TSCPopUpButtonCell {
                _tscCell.edgeInsets = edgeInsets
            }
            
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var title: String {
        set {
            super.title = newValue
            let attributedString =  NSAttributedString(string: newValue, attributes: [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor, NSFontAttributeName: NSFont.systemFontOfSize(12)])
            attributedTitle = attributedString
        }
        get {
            return attributedTitle.string
        }
    }
    
    /**
     The colour to highlight the text and border of the button with
     Uses the shared secondary color by default but may be overridden in it's IBDesignable property
     */
    @IBInspectable public var primaryColor: NSColor {
        didSet {
            updateButtonColours()
        }
    }
    
    /**
     The colour to highlight the text and border of the button with
     Uses blue color by default but may be overridden in it's IBDesignable property
     */
    @IBInspectable public var secondaryColor: NSColor {
        didSet {
            updateButtonColours()
        }
    }
    
    /**
     The border width of the button
     */
    @IBInspectable override public var borderWidth: CGFloat {
        get {
            guard let _layer = layer else { return 0.0 }
            return _layer.borderWidth
        }
        set {
            wantsLayer = true
            layer?.borderWidth = newValue
        }
    }
    
    /**
     The corner radius of the button
     */
    @IBInspectable override public var cornerRadius: CGFloat {
        get {
            guard let _layer = layer else { return 0.0 }
            return _layer.cornerRadius
        }
        set {
            wantsLayer = true
            layer?.cornerRadius = newValue
            layer?.masksToBounds = newValue > 0
        }
    }
    
    /**
     Switches the button to be of solid fill with rounded edges
     */
    @IBInspectable public var solidMode: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        
        primaryColor = NSColor.blueColor()
        secondaryColor = NSColor.whiteColor()
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        updateButtonColours()
    }
    
    /**
     Handles complete setup of the button. This is it's own method so we can call the same setup in prepareforinterfacebuilder as well
     */
    private func updateButtonColours() {
        
        layer?.borderWidth = borderWidth
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = false
        layer?.masksToBounds = true
        
        //Default state
        layer?.borderColor = primaryColor.CGColor
        
        if solidMode == true {
            
            layer?.backgroundColor = primaryColor.CGColor
        } else {
            
            layer?.backgroundColor = secondaryColor.CGColor
        }
        
        attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor])
    }
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        if let _borderColor = borderColor {
            layer?.borderColor = _borderColor.CGColor
        }
        updateButtonColours()
    }
    
    public override var intrinsicContentSize: NSSize {
        get {
            if let _ = cell as? TSCButtonCell {
                return super.intrinsicContentSize
            } else {
                let size = super.intrinsicContentSize
                return NSMakeSize(size.width + edgeInsets.width, size.height + edgeInsets.height)
            }
        }
    }
}
#endif

#if os(iOS)
/**
 A designable subclass of UIView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCView: UIView {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
    }
}
#elseif os(OSX)
/**
 A designable subclass of NSView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCView: NSView {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        wantsLayer = true
        layer?.cornerRadius = cornerRadius
        if let _borderColor = borderColor {
            layer?.borderColor = _borderColor.CGColor
        }
        layer?.borderWidth = borderWidth
        if let _backgroundColor = backgroundColor {
            layer?.backgroundColor = _backgroundColor.CGColor
        }
    }
}
#endif

#if os(iOS)
/**
 A designable subclass of UIImageView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCImageView: UIImageView {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
    }
}

/**
 A designable subclass of UITextView that allows customisation of border color and width, as well as other properties
 */
@IBDesignable public class TSCTextView: UITextView {
    
    public override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = borderWidth
    }
}

/**
 An inspectable extension of UIView that allows customisation of border color and width, as well as other properties
 */
public extension UIView {
    
    /**
     The border color of the view
     */
    @IBInspectable public var borderColor: UIColor {
        get {
            if let color = layer.borderColor {
                return UIColor(CGColor: color)
            }
            return UIColor.clearColor()
        }
        set {
            layer.borderColor = newValue.CGColor
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
}

#elseif os(OSX)
/**
 An inspectable extension of NSView that allows customisation of border color and width, as well as other properties
*/
public extension NSView {
    
    /**
     The background color of the view
     */
    @IBInspectable public var backgroundColor: NSColor? {
        get {
            guard let _layer = layer, color = _layer.backgroundColor else { return nil }
            return NSColor(CGColor: color)
        }
        set {
            wantsLayer = true
            guard let _layer = layer, _newValue = newValue else { return }
            _layer.backgroundColor = _newValue.CGColor
        }
    }
    
    /**
     The border color of the view
    */
    @IBInspectable public var borderColor: NSColor? {
        get {
            guard let _layer = layer, color = _layer.borderColor else { return nil }
            return NSColor(CGColor: color)
        }
        set {
            wantsLayer = true
            guard let _layer = layer, _newValue = newValue else { return }
            _layer.borderColor = _newValue.CGColor
        }
    }
    
    /**
     The border width of the label
     */
    @IBInspectable public var borderWidth: CGFloat {
        get {
            guard let _layer = layer else { return 0.0 }
            return _layer.borderWidth
        }
        set {
            wantsLayer = true
            layer?.borderWidth = newValue
        }
    }
    
    /**
     The corner radius of the view
     */
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            guard let _layer = layer else { return 0.0 }
            return _layer.cornerRadius
        }
        set {
            wantsLayer = true
            layer?.cornerRadius = newValue
            layer?.masksToBounds = newValue > 0
        }
    }
}
#endif
