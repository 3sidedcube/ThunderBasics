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
    class func preferredFont(forTextStyle style: UIFont.TextStyle, scaledBy scale: CGFloat, withSymbolicTraits symbolicTraits: UIFontDescriptor.SymbolicTraits? = nil, attributes: [UIFontDescriptor.AttributeName: Any]? = nil, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
		
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
    func withFontFamily(_ family: String, face: String? = nil) -> UIFont {
		
		var traits: [UIFontDescriptor.TraitKey : Any] = [:]
		
		// Make sure we only take known keys otherwise changes to family and face will be overwritten by preferredStyle
		if let existingTraits = fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.traits) as? [UIFontDescriptor.TraitKey : Any] {
			traits[UIFontDescriptor.TraitKey.weight] = existingTraits[UIFontDescriptor.TraitKey.weight]
			traits[UIFontDescriptor.TraitKey.slant] = existingTraits[UIFontDescriptor.TraitKey.slant]
			traits[UIFontDescriptor.TraitKey.width] = existingTraits[UIFontDescriptor.TraitKey.width]
		}
		
		var attributes = fontDescriptor.fontAttributes
		// Have to remove text style otherwise can't change weight
		attributes[UIFontDescriptor.AttributeName.textStyle] = nil
		// Create a new font traits dictionary
		attributes[UIFontDescriptor.AttributeName.traits] = traits
		
		var descriptor = UIFontDescriptor(name: fontName, size: pointSize).withFamily(family).addingAttributes(attributes)
		
		if let face = face {
			descriptor = descriptor.withFace(face)
		}
		
		return UIFont(descriptor: descriptor, size: descriptor.pointSize)
	}
	
	/// Adapts the font with the font family and weight provided
	///
	/// This is useful if you're using dynamic font sizing with a custom font, and should be used in place of
	/// calling `withFontFamily:face` and then `withWeight` because that combination of calls breaks your font
	///
	/// - Parameters:
	///   - family: The font family to convert this font to
	///   - weight: The font weight to convert this font to
	///
    func withFontFamily(_ family: String, weight: UIFont.Weight) -> UIFont {
		
		var traits: [UIFontDescriptor.TraitKey : Any] = [:]
		
		// Make sure we only take known keys otherwise changes to family and face will be overwritten by preferredStyle
		if let existingTraits = fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.traits) as? [UIFontDescriptor.TraitKey : Any] {
			traits[UIFontDescriptor.TraitKey.weight] = existingTraits[UIFontDescriptor.TraitKey.weight]
			traits[UIFontDescriptor.TraitKey.slant] = existingTraits[UIFontDescriptor.TraitKey.slant]
			traits[UIFontDescriptor.TraitKey.width] = existingTraits[UIFontDescriptor.TraitKey.width]
		}
		
		traits[UIFontDescriptor.TraitKey.weight] = weight
		
		var attributes = fontDescriptor.fontAttributes
		// Have to remove text style otherwise can't change weight
		attributes[UIFontDescriptor.AttributeName.textStyle] = nil
		// Create a new font traits dictionary
		attributes[UIFontDescriptor.AttributeName.traits] = traits
		
		let descriptor = UIFontDescriptor(name: fontName, size: pointSize).withFamily(family).addingAttributes(attributes)
		return UIFont(descriptor: descriptor, size: descriptor.pointSize)
	}
	
	/// Adapts the font with the font weight provided
	///
	/// This is useful if you're using dynamic font sizing with a custom weight
	///
	/// - Parameters:
	///   - weight: The font weight to convert this font to
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
		
		var traits: [UIFontDescriptor.TraitKey : Any] = [:]
		
		// Make sure we only take known keys otherwise changes to family and face will be overwritten by preferredStyle
		if let existingTraits = fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.traits) as? [UIFontDescriptor.TraitKey : Any] {
			traits[UIFontDescriptor.TraitKey.weight] = existingTraits[UIFontDescriptor.TraitKey.weight]
			traits[UIFontDescriptor.TraitKey.slant] = existingTraits[UIFontDescriptor.TraitKey.slant]
			traits[UIFontDescriptor.TraitKey.width] = existingTraits[UIFontDescriptor.TraitKey.width]
		}
		
		// Set the weight
		traits[UIFontDescriptor.TraitKey.weight] = weight

		var attributes = fontDescriptor.fontAttributes
		// Have to remove text style otherwise can't change weight
		attributes[UIFontDescriptor.AttributeName.textStyle] = nil
		// Create a new font traits dictionary
		attributes[UIFontDescriptor.AttributeName.traits] = traits
		
		var descriptor = fontDescriptor
		descriptor = descriptor.addingAttributes(attributes)
		return UIFont(descriptor: descriptor, size: descriptor.pointSize)
	}
}
