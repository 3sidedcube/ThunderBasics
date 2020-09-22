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
        let fileEnumerator = enumerator(atPath: directory)
        
        while let element = fileEnumerator?.nextObject() as? NSString {
            
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
/// - Returns: Whether there were un-migrateable attributes in the file.
func migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at path: String) -> Bool {
    
    print("Migrating user defined runtime attributes in \(path)")
    
    guard let migrator = InterfaceBuilderFileMigrator(filePath: path) else {
        print("Failed to read data as string from: \(path)")
        return false
    }
    migrator.migrate()
    
    if !migrator.unmigratableMatches.isEmpty {
        print("""
            Found umigrateable properties in \(path):

            \(migrator.unmigratableMatches.compactMap({ (keyValue) -> String in
                return "Line \(keyValue.key): \(keyValue.value)"
            }).joined(separator: "\n"))
            """
        )
    }
    
    // Save file to disk!
    let newData = migrator.string.data(using: .utf8)
    do {
        let fileURL = URL(fileURLWithPath: path)
        try newData?.write(to: fileURL)
        print("Wrote migrated file to \(path)")
    } catch {
        print("Failed to write migrated file to \(path)")
    }
    
    return !migrator.unmigratableMatches.isEmpty
}

print("This tool will make changes to the Interface Builder (.xib/.storyboard) files in the chosen directory. Please make sure you have no changes in your index before continuing")
print("Please enter the file path to the Project you want to migrate Interface Builder files to ThunderBasics 2.0.0")
var filePath = readLine(strippingNewline: true)
while filePath == nil {
    filePath = readLine(strippingNewline: true)
}

filePath = filePath?.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\\ ", with: " ")
print("Parsing contents of \(filePath!) for IB Files")

var seenUnmigrateableProperties: Bool = false

FileManager.default.recursivePathsForResource("xib", directory: filePath!).forEach { (xibPath) in
    let unmigrateable = migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at: xibPath)
    seenUnmigrateableProperties = unmigrateable || seenUnmigrateableProperties
}

FileManager.default.recursivePathsForResource("storyboard", directory: filePath!).forEach { (storyboardPath) in
    let unmigrateable = migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at: storyboardPath)
    seenUnmigrateableProperties = unmigrateable || seenUnmigrateableProperties
}

guard seenUnmigrateableProperties else { exit(0) }

print("""
    For all unmigrateable properties found above you will need to perform manual migration.

    The suggested steps for this are as follows:
    1. Search for the property in Xcode's search functionality.
    2. If the view in question doesn't have an IBOutlet, then create one.
    3. In the IBOutlet property for the view, add a `didSet` (If one doesn't already exist)
    4. Set the unmigrateable property manually in the `didSet` method
    """
)
