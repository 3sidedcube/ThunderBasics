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
/// - Returns: Whether there were un-migratable attributes in the file.
func migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at path: String) -> Bool {
    
    print("=> Migrating user defined runtime attributes in \(path)")
    
    guard let migrator = InterfaceBuilderFileMigrator(filePath: path) else {
        print("=> Failed to read data as string from: \(path)")
        return false
    }
    let unmigratableMatches = migrator.migrate()
    
    if !unmigratableMatches.isEmpty {
        print("""
            => Found un-migratable properties in \(path):

            \(unmigratableMatches.compactMap({ (keyValue) -> String in
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
        print("=> Wrote migrated file to \(path)")
    } catch {
        print("=> Failed to write migrated file to \(path)")
    }
    
    return !migrator.unmigratableMatches.isEmpty
}

var pValue: String?
let yesStrings = ["y", "Y", "yes", "YES"]

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "p:"), option != -1 {
    switch UnicodeScalar(CUnsignedChar(option)) {
    case "p":
        pValue = String(cString: optarg)
    default:
        fatalError("Unknown option")
    }
}

if pValue == nil {
    print("=> Running IBMigrationTool in your current working directory, to run in a different directory, provide the -p command line argument")
}

// See https://stackoverflow.com/questions/44193114/swift-3-read-terminal-current-working-directory for why we use `FileManager` here
let filePath = pValue ?? FileManager.default.currentDirectoryPath

print("=> This tool will make changes to the Interface Builder (.xib/.storyboard) files in the chosen directory. Please make sure you have no changes in your index before continuing. Please type \"yes\" when you have done this.")
var yesInput = readLine(strippingNewline: true)
while !yesStrings.contains(yesInput ?? "") {
    yesInput = readLine(strippingNewline: true)
}

print("=> Finding Interface Builder files in \(filePath)")

var seenUnmigratableProperties: Bool = false
var noFilesFound: Bool = true

FileManager.default.recursivePathsForResource("xib", directory: filePath).forEach { (xibPath) in
    noFilesFound = false
    let unmigratable = migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at: xibPath)
    seenUnmigratableProperties = unmigratable || seenUnmigratableProperties
}

FileManager.default.recursivePathsForResource("storyboard", directory: filePath).forEach { (storyboardPath) in
    noFilesFound = false
    let unmigratable = migrateUserDefinedRuntimeAttributesInInterfaceBuilderFile(at: storyboardPath)
    seenUnmigratableProperties = unmigratable || seenUnmigratableProperties
}

if noFilesFound {
    print("=> No Interface Builder files found in \(filePath) or any of it's sub-directories")
}

guard seenUnmigratableProperties else { exit(0) }

print("""
    => For all un-migratable properties found above you will need to perform manual migration.

    The suggested steps for this are as follows:
    1. Search for the property in Xcode's search functionality.
    2. If the view in question doesn't have an IBOutlet, then create one.
    3. In the IBOutlet property for the view, add a `didSet` (If one doesn't already exist)
    4. Set the un-migratable property manually in the `didSet` method
    """
)
