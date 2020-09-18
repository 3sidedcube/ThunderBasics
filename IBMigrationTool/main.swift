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
    
    print("Migrating user defined runtime attributes in \(path)")
    
    guard let migrator = InterfaceBuilderFileMigrator(filePath: path) else {
        print("Failed to read data as string from: \(path)")
        return
    }
    migrator.migrate()
    
    // Save file to disk!
    let newData = migrator.string.data(using: .utf8)
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

