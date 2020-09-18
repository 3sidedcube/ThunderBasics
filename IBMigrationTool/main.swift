//
//  main.swift
//  IBMigrationTool
//
//  Created by Simon Mitchell on 17/09/2020.
//  Copyright © 2020 threesidedcube. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// Recurses the given directory for files with a given extension
    /// - Parameters:
    ///   - type: The extension to find files for
    ///   - directory: The directory to search in
    /// - Returns: An array of file paths
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

/// Converts all `UIView+Displayable` runtime attributes to use the
/// `CALayer` equivalents in the file at the given path
/// - Parameter path: The file path to convert
func migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at path: String) {
        
    let fileURL = URL(fileURLWithPath: path)
    guard let data = try? Data(contentsOf: fileURL),
          var string = String(data: data, encoding: .utf8) else { return }
    
    print("Migrating user defined runtime attributes in \(path)")
    
    // These use the same type as `CALayer` equivalents, so can be
    // mapped simply using the same regex
    let directlyMappableAttributes: [(String, String)] = [
        ("color", "borderColor"),
        ("number", "borderWidth"),
        ("number", "cornerRadius"),
        ("color", "shadowColor"),
        ("number", "shadowOpacity"),
        ("number", "shadowRadius")
    ]
    
    directlyMappableAttributes.forEach { (attribute)  in
                
        string = string.replacingOccurrences(
            of: "<userDefinedRuntimeAttribute(\\s+)type=\"\(attribute.0)\"(\\s+)keyPath=\"(\(attribute.1))\">",
            with: "<userDefinedRuntimeAttribute$1type=\"\(attribute.0)\"$2keyPath=\"layer.$3\">",
            options: .regularExpression,
            range: nil
        )
    }
    
    // shadowOffset is a bit more complex because we used `CGPoint` but
    // `CALayer` uses `CGSize`
    
    // Note this regex isn't perfect as it allows for x,y to take the form 1.2.1.3.1.2 e.t.c
    // however this should be impossible to enter in Interface Builder and it makes replacing it
    // far simpler so we will leave be for now!
    string = string.replacingOccurrences(
        of: "<userDefinedRuntimeAttribute(\\s+)type=\"point\"(\\s+)keyPath=\"shadowOffset\">(\\s+)(<point(\\s)+key=\"value\"(\\s)+x=\"([.\\d]+)\"(\\s+)y=\"([.\\d]+)\"\\/>)",
        with: "<userDefinedRuntimeAttribute$1type=\"size\"$2keyPath=\"layer.shadowOffset\">$3<size$5key=\"value\"$6width=\"$7\"$8height=\"$9\"\\/>",
        options: .regularExpression,
        range: nil
    )
    
    // Save file to disk!
    let newData = string.data(using: .utf8)
    do {
        try newData?.write(to: fileURL)
        print("Wrote migrated file to \(path)")
    } catch {
        print("Failed to write migrated file to \(path)")
    }
}

print("This tool will make changes to the Interface Builder (.xib/.storyboard) files in the chosen directory. Please make sure you have no changes in your index before continuing")
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

