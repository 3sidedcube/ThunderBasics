//
//  JSONSerialization+FromFile.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 06/02/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

import Foundation

extension JSONSerialization {
	
	open class func jsonObject(with resource: String?, extension fileExtension: String?, in bundle: Bundle = .main, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
		
		guard let path = bundle.url(forResource: resource, withExtension: fileExtension) else {
			throw JSONSerializationError.fileNotFoundInBundle
		}
		
		do {
			let object = try JSONSerialization.jsonObject(with: path, options: opt)
			return object
		} catch let error {
			throw error
		}
	}
	
	open class func jsonObject(with file: URL, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
		
		do {
			let data = try Data(contentsOf: file)
			let object = try JSONSerialization.jsonObject(with: data, options: opt)
			return object
		} catch let error {
			throw error
		}
	}
}

/// Errors for JSON Serialization extension
///
/// - noFileFoundInBundle: No file was found for the specified resource in the bundle
enum JSONSerializationError: Error {
	case fileNotFoundInBundle
}
