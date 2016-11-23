//
//  TSCLabel.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 19/01/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

#if os(iOS)
    
    import UIKit
    
    /**
     A designable subclass of UIView that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable public class TSCView: UIView {
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    /**
     A designable subclass of UILabel that allows customisation of border color and width, as well as other properties
     */
    
    @IBDesignable public class TSCLabel: UILabel {
        
        /**
         The edge insets of the label
         */
        @IBInspectable public var textInsets: CGSize = CGSize.zero
        
        private var edgeInsets: UIEdgeInsets {
            get {
                return UIEdgeInsets(top: textInsets.height, left: textInsets.width, bottom: textInsets.height, right: textInsets.width)
            }
        }
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
        }
        
        public override func drawText(in rect: CGRect) {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
        }
        
        override public func sizeThatFits(_ size: CGSize) -> CGSize {
            
            var adjSize = super.sizeThatFits(size)
            adjSize.width += textInsets.width * 2
            adjSize.height += textInsets.height * 2
            
            return adjSize
        }
        
        public override var intrinsicContentSize: CGSize {
            
            var contentSize = super.intrinsicContentSize
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
        @IBInspectable public var textInsets: CGSize = CGSize.zero
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
        }
        
        public convenience init(insets: CGSize) {
            self.init(frame: CGRect.zero)
            self.textInsets = insets
        }
        
        // placeholder position
        override public func textRect(forBounds bounds: CGRect) -> CGRect {
            return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(textInsets.height, textInsets.width, textInsets.height, textInsets.width)))
        }
        
        // text position
        override public func editingRect(forBounds bounds: CGRect) -> CGRect {
            return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(textInsets.height, textInsets.width, textInsets.height, textInsets.width)))
        }
        
    }
    
    /**
     A designable subclass of UIButton that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable public class TSCButton: UIButton {
        
        /**
         Whether the primary/secondary color should be overriden by borderColor property
         */
        @IBInspectable public var useBorderColor: Bool = false {
            didSet {
                updateButtonColours()
            }
        }
        
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
            
            primaryColor = UIColor.blue
            secondaryColor = UIColor.white
            super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            
            primaryColor = UIColor.blue
            secondaryColor = UIColor.white
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
            layer.borderColor = useBorderColor ? borderColor?.cgColor : primaryColor.cgColor
            
            if solidMode == true {
                
                layer.backgroundColor = primaryColor.cgColor
                setTitleColor(secondaryColor, for: [])
                
            } else {
                
                layer.backgroundColor = UIColor.clear.cgColor
                setTitleColor(secondaryColor, for: [])
            }
        }
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
            updateButtonColours()
        }
    }
    
    /**
     A designable subclass of UIImageView that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable public class TSCImageView: UIImageView {
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
            layer.shadowColor = shadowColor?.cgColor
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
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    /**
     An inspectable extension of UIView that allows customisation of border color and width, as well as other properties
     */
    public extension UIView {
        
        /**
         The border color of the view
         */
        @IBInspectable public var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                layer.borderColor = newValue?.cgColor
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
                layer.shadowColor = newValue!.cgColor
            }
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor:color)
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
    
#elseif os(OSX) || os(macOS)
    import AppKit
    
    @IBDesignable public class TSCTextField: NSTextField {
        /**
         The edge insets of the text field
         */
        @IBInspectable public var textInsets: CGSize = CGSize.zero
    }
    
    public extension TSCTextField {
        
        public override func awakeFromNib() {
            
            super.awakeFromNib()
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let _borderColor = borderColor {
                layer?.borderColor = _borderColor.cgColor
            }
            layer?.borderWidth = borderWidth
        }
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let _borderColor = borderColor {
                layer?.borderColor = _borderColor.cgColor
            }
            layer?.borderWidth = borderWidth
        }
    }
    
    /**
     An inspectable extension of NSView that allows customisation of border color and width, as well as other properties
     */
    
    import ObjectiveC
    
    private var backgroundColorKey: UInt8 = 0
    private var borderColorKey: UInt8 = 1
    private var borderWidthKey: UInt8 = 2
    private var cornerRadiusKey: UInt8 = 3
    
    public extension NSView {
        
        /**
         The background color of the view
         */
        @IBInspectable public var backgroundColor: NSColor? {
            get {
                guard let _layer = layer, let color = _layer.backgroundColor else {
                    return objc_getAssociatedObject(self, &backgroundColorKey) as? NSColor
                }
                return NSColor(cgColor: color)
            }
            set {
                wantsLayer = true
                objc_setAssociatedObject(self, &backgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                if let _newValue = newValue {
                    layer?.backgroundColor = _newValue.cgColor
                }
            }
        }
        
        /**
         The border color of the view
         */
        @IBInspectable public var borderColor: NSColor? {
            get {
                return objc_getAssociatedObject(self, &borderColorKey) as? NSColor
            }
            set {
                wantsLayer = true
                objc_setAssociatedObject(self, &borderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                if let _newValue = newValue {
                    layer?.borderColor = _newValue.cgColor
                }
            }
        }
        
        /**
         The border width of the label
         */
        @IBInspectable public var borderWidth: CGFloat {
            get {
                guard let width = (objc_getAssociatedObject(self, &borderWidthKey) as? NSNumber)?.floatValue else { return 0.0 }
                return CGFloat(width)
            }
            set {
                wantsLayer = true
                objc_setAssociatedObject(self, &borderWidthKey, NSNumber(value: Float(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                layer?.borderWidth = newValue
            }
        }
        
        /**
         The corner radius of the view
         */
        @IBInspectable public var cornerRadius: CGFloat {
            get {
                guard let width = (objc_getAssociatedObject(self, &cornerRadiusKey) as? NSNumber)?.floatValue else { return 0.0 }
                return CGFloat(width)
            }
            set {
                wantsLayer = true
                objc_setAssociatedObject(self, &cornerRadiusKey, NSNumber(value: Float(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                layer?.cornerRadius = newValue
                layer?.masksToBounds = newValue > 0
            }
        }
    }
    
    public class TSCButtonCell: NSButtonCell {
        
        /**
         The edge insets of the button
         */
        public var edgeInsets: NSSize = NSMakeSize(0, 0)
        
        
        public override func drawingRect(forBounds: NSRect) -> NSRect {
            
            let newRect = NSInsetRect(forBounds, edgeInsets.width/2, edgeInsets.height/2)
            return super.drawingRect(forBounds: newRect)
        }
    }
    
    /**
     A designable subclass of NSButton that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable
    public class TSCButton: NSButton {
        
        /**
         The edge insets of the button
         */
        @IBInspectable open var edgeInsets: NSSize = NSMakeSize(0, 0) {
            didSet {
                
                if let _tscCell = cell as? TSCButtonCell {
                    _tscCell.edgeInsets = edgeInsets
                }
                
                invalidateIntrinsicContentSize()
            }
        }
        
        override open var alignment: NSTextAlignment {
            didSet {
                updateTitle(title)
            }
        }
        
        override open var font: NSFont? {
            didSet {
                updateTitle(title)
            }
        }
        
        override open var title: String {
            set {
                super.title = newValue
                updateTitle(newValue)
            }
            get {
                return attributedTitle.string
            }
        }
        
        private func updateTitle(_ newTitle: String) {
            
            let paragraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = alignment
            
            let _font = font != nil ? font! : NSFont.systemFont(ofSize: NSFont.systemFontSize())
            
            let attributes = [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor, NSFontAttributeName: _font, NSParagraphStyleAttributeName: paragraphStyle]
            attributedTitle = NSAttributedString(string: newTitle, attributes: attributes)
        }
        
        /**
         The colour to highlight the text and border of the button with
         Uses the shared secondary color by default but may be overridden in it's IBDesignable property
         */
        @IBInspectable open var primaryColor: NSColor {
            didSet {
                updateButtonColours()
            }
        }
        
        /**
         The colour to highlight the text and border of the button with
         Uses blue color by default but may be overridden in it's IBDesignable property
         */
        @IBInspectable open var secondaryColor: NSColor {
            didSet {
                updateButtonColours()
            }
        }
        
        /**
         The border width of the button
         */
        @IBInspectable override open var borderWidth: CGFloat {
            didSet {
                wantsLayer = true
                layer?.borderWidth = borderWidth
            }
        }
        
        /**
         The corner radius of the button
         */
        @IBInspectable override open var cornerRadius: CGFloat {
            didSet {
                wantsLayer = true
                layer?.cornerRadius = cornerRadius
                layer?.masksToBounds = cornerRadius > 0
            }
        }
        
        /**
         Switches the button to be of solid fill with rounded edges
         */
        @IBInspectable open var solidMode: Bool = false
        
        required public init?(coder aDecoder: NSCoder) {
            
            primaryColor = NSColor.blue
            secondaryColor = NSColor.white
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
            
            wantsLayer = true
            layer?.borderWidth = borderWidth
            layer?.cornerRadius = cornerRadius
            layer?.masksToBounds = false
            layer?.masksToBounds = true
            
            //Default state
            layer?.borderColor = primaryColor.cgColor
            
            if solidMode == true {
                
                layer?.backgroundColor = primaryColor.cgColor
            } else {
                
                layer?.backgroundColor = secondaryColor.cgColor
            }
            
            attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor])
        }
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let _borderColor = borderColor {
                layer?.borderColor = _borderColor.cgColor
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
        
        
        public override func drawingRect(forBounds : NSRect) -> NSRect {
            
            let newRect = NSInsetRect(forBounds, edgeInsets.width/2, edgeInsets.height/2)
            return super.drawingRect(forBounds: newRect)
        }
        
        public override func titleRect(forBounds: NSRect) -> NSRect {
            
            let newRect = NSInsetRect(forBounds, edgeInsets.width/2, edgeInsets.height/2)
            return super.titleRect(forBounds: newRect)
        }
        
        public override func imageRect(forBounds: NSRect) -> NSRect {
            
            let newRect = NSInsetRect(forBounds, edgeInsets.width/2, edgeInsets.height/2)
            return super.imageRect(forBounds: newRect)
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
                let attributedString =  NSAttributedString(string: newValue, attributes: [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor, NSFontAttributeName: NSFont.systemFont(ofSize: 12)])
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
            didSet {
                wantsLayer = true
                layer?.borderWidth = borderWidth
            }
        }
        
        /**
         The corner radius of the button
         */
        @IBInspectable override public var cornerRadius: CGFloat {
            didSet {
                wantsLayer = true
                layer?.cornerRadius = cornerRadius
                layer?.masksToBounds = cornerRadius > 0
            }
        }
        
        /**
         Switches the button to be of solid fill with rounded edges
         */
        @IBInspectable public var solidMode: Bool = false
        
        required public init?(coder aDecoder: NSCoder) {
            
            primaryColor = NSColor.blue
            secondaryColor = NSColor.white
            super.init(coder: aDecoder)
        }
        
        override public func awakeFromNib() {
            
            super.awakeFromNib()
            updateButtonColours()
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let _borderColor = borderColor {
                layer?.borderColor = _borderColor.cgColor
            }
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
            layer?.borderColor = primaryColor.cgColor
            
            if solidMode == true {
                
                layer?.backgroundColor = primaryColor.cgColor
            } else {
                
                layer?.backgroundColor = secondaryColor.cgColor
            }
            
            attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: solidMode ? secondaryColor : primaryColor])
        }
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let _borderColor = borderColor {
                layer?.borderColor = _borderColor.cgColor
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
    
    /**
     A designable subclass of NSView that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable public class TSCView: NSView {
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            wantsLayer = true
        }
        
        public override func awakeFromNib() {
            
            super.awakeFromNib()
            wantsLayer = true
            setupView()
        }
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            setupView()
        }
        
        private func setupView() {
            
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let _borderColor = borderColor {
                layer?.borderColor = _borderColor.cgColor
            }
            layer?.borderWidth = borderWidth
            if let _backgroundColor = backgroundColor {
                layer?.backgroundColor = _backgroundColor.cgColor
            }
        }
    }
#endif
