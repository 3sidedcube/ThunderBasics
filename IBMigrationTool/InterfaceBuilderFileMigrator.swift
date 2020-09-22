//
//  InterfaceBuilderFileMigrator.swift
//  ThunderBasics
//
//  Created by Simon Mitchell on 18/09/2020.
//  Copyright © 2020 threesidedcube. All rights reserved.
//

import Foundation

/// A class responsible for migrating an Interface Builder to fix issues
/// when upgrading to `ThunderBasics` v2.0.0
final class InterfaceBuilderFileMigrator {
    
    /// A structural representation of a user-defined IB attribute
    struct UserDefinedAttribute {
        
        /// A type for the given attribute
        enum AttributeType: String {
            
            case color
            
            case number
            
            var isMigrateable: Bool {
                switch self {
                case .color:
                    return false
                default:
                    return true
                }
            }
        }
        
        /// The type of the attribute
        let type: AttributeType
        
        /// The key for the attribute
        let key: String
        
        /// Returns whether the attribute is migrateable
        var isMigrateable: Bool {
            return type.isMigrateable
        }
    }
    
    static let directlyMappableAttributes: [UserDefinedAttribute] = [
        .init(type: .color, key: "borderColor"),
        .init(type: .number, key: "borderWidth"),
        .init(type: .number, key: "cornerRadius"),
        .init(type: .color, key: "shadowColor"),
        .init(type: .number, key: "shadowOpacity"),
        .init(type: .number, key: "shadowRadius")
    ]
    
    static let removedCustomClasses: [String] = [
        "TSCTextView",
        "TSCView",
        "TSCImageView"
    ]
    
    /// Represents the current contents of the interface builder file
    ///
    /// - Note: This will be changed by calling the `migrate` function to
    /// represent the fixed version of the file!
    var string: String
    
    /// String matches for umigrateable text. Map from line number to the string matched.
    var unmigratableMatches: [Int: String] = [:]
    
    convenience init?(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        guard let fileString = String(data: data, encoding: .utf8) else {
            return nil
        }
        self.init(string: fileString)
    }
    
    init(string: String) {
        self.string = string
    }
    
    /// Performs migration of the current file, storing the result in `string`
    func migrate() {
        unmigratableMatches = [:]
        migrateUserDefinedRuntimeAttributes()
        migrateRemovedCustomClasses()
    }
    
    private func migrateRemovedCustomClasses() {
        
        Self.removedCustomClasses.forEach { (customClass) in
            
            // Have to catch all of this in one redux as could appear in either order but if we do one check before the other
            // we may miss/break other cases!
            //
            // check for customModule="ThunderBasics" ... "customClass"=customClass || "customClass"=customClass ... customModule="ThunderBasics"
            string = string.replacingOccurrences(
                of: "(customModule=\"ThunderBasics\"([^>]*))?\\s*customClass=\"\(customClass)\"\\s*(([^>]*)customModule=\"ThunderBasics\")?",
                with: "$2$4", // We will only either have $2 or $4 so we don't need a space between them!
                options: .regularExpression,
                range: nil
            )
        }
    }
    
    private func migrateUserDefinedRuntimeAttributes() {
        
        // These use the same type as `CALayer` equivalents, so can be
        // mapped simply using the same regex
        Self.directlyMappableAttributes.forEach { (attribute)  in
            
            if attribute.isMigrateable {
                string = string.replacingOccurrences(
                    of: "<userDefinedRuntimeAttribute(\\s+)type=\"\(attribute.type.rawValue)\"(\\s+)keyPath=\"(\(attribute.key))\">",
                    with: "<userDefinedRuntimeAttribute$1type=\"\(attribute.type.rawValue)\"$2keyPath=\"layer.$3\">",
                    options: .regularExpression,
                    range: nil
                )
            } else if let matchRegex = try? NSRegularExpression(
                pattern: "<userDefinedRuntimeAttribute\\s+type=\"\(attribute.type.rawValue)\"\\s+keyPath=\"(\(attribute.key))\">",
                options: []
            ) {
                var lineNumber: Int = 0
                string.enumerateLines { (line, _) in
                    if matchRegex.numberOfMatches(
                        in: line,
                        options: [],
                        range: NSRange(line.startIndex..<line.endIndex, in: line)
                    ) > 0 {
                        self.unmigratableMatches[lineNumber] = line.trimmingCharacters(in: .whitespaces)
                    }
                    lineNumber += 1
                }
            }
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
    }
}
