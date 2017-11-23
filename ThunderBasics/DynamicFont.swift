//
//  DynamicFont.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 08/11/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import Foundation

public extension UIFont {
	
	/// Creates a font for a defined text style with the font size scaled by a proportion and with given symbolic traits applied
	///
	/// - Parameters:
	///   - style: The style of font, see `UIFontTextStyle`
	///   - scale: The scale to increase the font size by (1 would result in the exact same font)
	///   - symbolicTraits: Symbolic constraints to apply to the default font
	///   - traitCollection: The trait collection the font should be for
	/// - Returns: A font converted given the above parameters
	public class func preferredFont(forTextStyle style: UIFontTextStyle, scaledBy scale: CGFloat, withSymbolicTraits symbolicTraits: UIFontDescriptorSymbolicTraits? = nil, attributes: [UIFontDescriptor.AttributeName: Any]? = nil, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
		
		var descriptor: UIFontDescriptor
		
		if #available(iOS 10, *) {
			descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traitCollection)
		} else {
			descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
		}
		
		if let attributes = attributes {
			descriptor = descriptor.addingAttributes(attributes)
		}
		
		if let symbolicTraits = symbolicTraits {
			descriptor = descriptor.withSymbolicTraits(symbolicTraits) ?? descriptor
		}
		
		let pointSize = descriptor.pointSize * scale
		
		return UIFont(descriptor: descriptor, size: pointSize)
	}
	
	/// Adapts the font with the font family and face provided
	///
	/// This is useful if you're using dynamic font sizing with a custom font
	///
	/// - Parameters:
	///   - family: The font family to convert this font to
	///   - face: The font face to convert this font to
	public func withFontFamily(_ family: String, face: String? = nil) -> UIFont {
		
		var descriptor = fontDescriptor.withFamily(family)
		
		if let face = face {
			descriptor = descriptor.withFace(face)
		}
		
		return UIFont(descriptor: descriptor, size: descriptor.pointSize)
	}
	
	/// Adapts the font with the font weight provided
	///
	/// This is useful if you're using dynamic font sizing with a custom weight
	///
	/// - Parameters:
	///   - weight: The font weight to convert this font to
	public func withWeight(_ weight: UIFont.Weight) -> UIFont {
		
		let attributes: [UIFontDescriptor.AttributeName: Any] = [
			.traits: [
				UIFontDescriptor.TraitKey.weight: weight
			]
		]
		
		let descriptor = fontDescriptor.addingAttributes(attributes)
		return UIFont(descriptor: descriptor, size: descriptor.pointSize)
	}
}