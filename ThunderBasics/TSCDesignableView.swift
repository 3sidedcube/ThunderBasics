//
//  TSCLabel.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 19/01/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

#if os(iOS)
	
	import UIKit
	
	/// A constraint which can be used in place of NSLayoutConstraint and takes the devices scale into account with it's constant value. Dividing it by the screen scale in awakeFromNib
	public class ScaleBasedConstraint: NSLayoutConstraint {
		override public func awakeFromNib() {
			super.awakeFromNib()
			self.constant = self.constant / UIScreen.main.scale
		}
	}

    /**
     A designable subclass of UIView that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable open class TSCView: UIView {
        
		open override func prepareForInterfaceBuilder() {
            
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
    
    @IBDesignable open class TSCLabel: UILabel {
		
		/**
		The left edge insets of the label
		*/
		@IBInspectable open var leftInset: CGFloat = 0
		
		/**
		The right edge insets of the label
		*/
		@IBInspectable open var rightInset: CGFloat = 0
		
		/**
		The top edge insets of the label
		*/
		@IBInspectable open var topInset: CGFloat = 0
		
		/**
		The bottom edge insets of the label
		*/
		@IBInspectable open var bottomInset: CGFloat = 0
        
		private var edgeInsets: UIEdgeInsets {
			get {
				return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
			}
		}

        
		open override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
        }
        
		override open func drawText(in rect: CGRect) {
			super.drawText(in: rect.inset(by: edgeInsets))
        }
        
		override open func sizeThatFits(_ size: CGSize) -> CGSize {
            
            var adjSize = super.sizeThatFits(size)
			adjSize.width += leftInset + rightInset
			adjSize.height += topInset + bottomInset
            
            return adjSize
        }
		
		open override var intrinsicContentSize: CGSize {
			var superSize = super.intrinsicContentSize
			superSize.width += leftInset + rightInset
			superSize.height += topInset + bottomInset
			return superSize
		}
    }
    /**
     A designable subclass of UITextField that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable open class TSCTextField: UITextField {
		
		/**
		The left edge insets of the label
		*/
		@IBInspectable open var leftInset: CGFloat = 0
		
		/**
		The right edge insets of the label
		*/
		@IBInspectable open var rightInset: CGFloat = 0
		
		/**
		The top edge insets of the label
		*/
		@IBInspectable open var topInset: CGFloat = 0
		
		/**
		The bottom edge insets of the label
		*/
		@IBInspectable open var bottomInset: CGFloat = 0
		
		private var edgeInsets: UIEdgeInsets {
			get {
				return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
			}
		}

        
		open override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
            
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: shadowOffset.x,height: shadowOffset.y)
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = shadowOpacity
        }
        
		public convenience init(insets: UIEdgeInsets) {
			self.init(frame: CGRect.zero)
			leftInset = insets.left
			rightInset = insets.right
			topInset = insets.top
			bottomInset = insets.bottom
        }
		
		// left view position
		override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
			var superLeftRect = super.leftViewRect(forBounds: bounds)
			superLeftRect.origin.x = superLeftRect.origin.x - edgeInsets.right
			return superLeftRect
		}

        
        // placeholder position
		override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return super.textRect(forBounds: bounds.inset(by: edgeInsets))
        }
        
        // text position
		override open func editingRect(forBounds bounds: CGRect) -> CGRect {
			return super.editingRect(forBounds: bounds.inset(by: edgeInsets))
		}
		
		// right view position
		open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
			var superRightRect = super.rightViewRect(forBounds: bounds)
			superRightRect.origin.x = superRightRect.origin.x - edgeInsets.right
			return superRightRect
		}
    }
    
    /**
     A designable subclass of UIButton that allows customisation of border color and width, as well as other properties
     */
    @IBDesignable open class TSCButton: UIButton {
        
        /**
         Whether the primary/secondary color should be overriden by borderColor property
         */
        @IBInspectable open var useBorderColor: Bool = false {
            didSet {
                updateButtonColours()
            }
        }
        
        /**
         The colour to highlight the text and border of the button with
         Uses the shared secondary color by default but may be overridden in it's IBDesignable property
         */
        @IBInspectable open var primaryColor: UIColor {
            didSet {
                updateButtonColours()
            }
        }
        
        /**
         The colour to highlight the text and border of the button with
         Uses blue color by default but may be overridden in it's IBDesignable property
         */
        @IBInspectable open var secondaryColor: UIColor {
            didSet {
                updateButtonColours()
            }
        }
        
        /**
         Switches the button to be of solid fill with rounded edges
         */
        @IBInspectable open var solidMode: Bool = false {
            didSet {
                updateButtonColours()
            }
        }
        
        /// Whether the buttons corners should be rounded by default
        @IBInspectable open var roundCorners: Bool = true {
            didSet {
                updateButtonColours()
            }
        }
        
        required public init?(coder aDecoder: NSCoder) {
            
            primaryColor = UIColor.blue
            secondaryColor = UIColor.white
            super.init(coder: aDecoder)
        }
        
        override public init(frame: CGRect) {
            
            primaryColor = UIColor.blue
            secondaryColor = UIColor.white
            super.init(frame: frame)
        }
        
		override open func awakeFromNib() {
            
            super.awakeFromNib()
            updateButtonColours()
        }
        
        /**
         Handles complete setup of the button. This is it's own method so we can call the same setup in prepareforinterfacebuilder as well
         */
        private func updateButtonColours() {
            
            layer.borderWidth = borderWidth != 0 ? borderWidth : 2.0
            layer.cornerRadius = roundCorners ? (cornerRadius != 0 ? cornerRadius : 5.0) : 0
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
        
		open override func prepareForInterfaceBuilder() {
            
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
    @IBDesignable open class TSCImageView: UIImageView {
        
        open override func prepareForInterfaceBuilder() {
            
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
    @IBDesignable open class TSCTextView: UITextView {
        
        open override func prepareForInterfaceBuilder() {
            
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
        @IBInspectable var borderColor: UIColor? {
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
        @IBInspectable var borderWidth: CGFloat {
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
        @IBInspectable var cornerRadius: CGFloat {
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
        
        override public func awakeFromNib() {
            
            super.awakeFromNib()
            wantsLayer = true
            layer?.cornerRadius = cornerRadius
            if let borderColor = borderColor {
                layer?.borderColor = borderColor.cgColor
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
    public extension NSView {
        
        /**
         The background color of the view
         */
        @IBInspectable public var backgroundColor: NSColor? {
            get {
                guard let _layer = layer, let color = _layer.backgroundColor else { return nil }
                return NSColor(cgColor: color)
            }
            set {
                wantsLayer = true
                guard let _layer = layer, let _newValue = newValue else { return }
                _layer.backgroundColor = _newValue.cgColor
            }
        }
        
        /**
         The border color of the view
         */
        @IBInspectable public var borderColor: NSColor? {
            get {
                guard let _layer = layer, let color = _layer.borderColor else { return nil }
                return NSColor(cgColor: color)
            }
            set {
                wantsLayer = true
                guard let _layer = layer, let _newValue = newValue else { return }
                _layer.borderColor = _newValue.cgColor
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
            
            let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = alignment

            let _font = font != nil ? font! : NSFont.systemFont(ofSize: NSFont.systemFontSize)
            
            let attributes = [NSAttributedStringKey.foregroundColor: solidMode ? secondaryColor : primaryColor, NSAttributedStringKey.font: _font, NSAttributedStringKey.paragraphStyle: paragraphStyle]
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
        @IBInspectable override open var cornerRadius: CGFloat {
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
            
            attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: solidMode ? secondaryColor : primaryColor])
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
                let attributedString =  NSAttributedString(string: newValue, attributes: [NSAttributedStringKey.foregroundColor: solidMode ? secondaryColor : primaryColor, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 12)])
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
            
            primaryColor = NSColor.blue
            secondaryColor = NSColor.white
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
            layer?.borderColor = primaryColor.cgColor
            
            if solidMode == true {
                
                layer?.backgroundColor = primaryColor.cgColor
            } else {
                
                layer?.backgroundColor = secondaryColor.cgColor
            }
            
            attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: solidMode ? secondaryColor : primaryColor])
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
        
        public override func prepareForInterfaceBuilder() {
            
            super.prepareForInterfaceBuilder()
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
