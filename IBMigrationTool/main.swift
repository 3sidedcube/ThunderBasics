//
//  main.swift
//  IBMigrationTool
//
//  Created by Simon Mitchell on 17/09/2020.
//  Copyright © 2020 threesidedcube. All rights reserved.
//

import Foundation

extension FileManager {
    
    func recursivePathsForResource(_ type: String?, directory: String) -> [String] {
        
        var filePaths: [String] = []
        let enumerator = FileManager.default.enumerator(atPath: directory)
        
        while let element = enumerator?.nextObject() as? NSString {
            
            if type == nil || element.pathExtension == type {
                filePaths.append(directory + "/" + (element as String))
            }
        }
        
        return filePaths
    }
}

extension NSRegularExpression {
    
    class func userRuntimeAttributeRegex(type: String, keyPath: String) -> NSRegularExpression {
        
        return try! NSRegularExpression(pattern: "<userDefinedRuntimeAttribute\\s+type=\"\(type)\"\\s+keyPath=\"\(keyPath)\">", options: .caseInsensitive)
    }
}

func migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at path: String) {
        
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)), var string = String(data: data, encoding: String.Encoding.utf8) else { return }
    
    print("Migrating user defined runtime attributes in \(path)")
    
    let borderColorRegex = NSRegularExpression.userRuntimeAttributeRegex(type: "color", keyPath: "borderColor")
    
    let matches = borderColorRegex.matches(
        in: string,
        options: .reportCompletion,
        range: NSRange(string.startIndex..<string.endIndex, in: string)
    )
    
    print("Found matches in string", matches)
    
}

print("Please enter the file path to the Project you want to migrate Interface Builder files to ThunderBasics 3.0.0")
var filePath = readLine(strippingNewline: true)
while filePath == nil {
    filePath = readLine(strippingNewline: true)
}

filePath = filePath?.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\\ ", with: " ")
print("Parsing contents of \(filePath!) for IB Files")

FileManager.default.recursivePathsForResource("xib", directory: filePath!).forEach { (xibPath) in
    migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at: xibPath)
}

FileManager.default.recursivePathsForResource("storyboard", directory: filePath!).forEach { (storyboardPath) in
    migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at: storyboardPath)
}

