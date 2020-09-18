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
    
    static let directlyMappableAttributes: [(String, String)] = [
        ("color", "borderColor"),
        ("number", "borderWidth"),
        ("number", "cornerRadius"),
        ("color", "shadowColor"),
        ("number", "shadowOpacity"),
        ("number", "shadowRadius")
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
    }
}
