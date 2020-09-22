//
//  IBMigrationToolTests.swift
//  IBMigrationToolTests
//
//  Created by Simon Mitchell on 18/09/2020.
//  Copyright © 2020 threesidedcube. All rights reserved.
//

import XCTest

class IBMigrationToolTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStoryboardFileMigratesCorrectly() {
        
        // May not be .storyboard (Can't include iOS storyboard in macOS test target), but the contents are the same!
        guard let initialPath = Bundle.init(for: IBMigrationToolTests.self).url(forResource: "TestStoryboard", withExtension: "xml") else {
            XCTFail("Missing TestStoryboard.xml in test target!")
            return
        }
        guard let finalPath = Bundle.init(for: IBMigrationToolTests.self).url(forResource: "TestStoryboard-Migrated", withExtension: "xml") else {
            XCTFail("Missing TestStoryboard-Migrated in test target!")
            return
        }
        guard let finalString = try? String(contentsOf: finalPath) else {
            XCTFail("Failed to read TestStoryboard-Migrated as string!")
            return
        }
        let migrator = InterfaceBuilderFileMigrator(filePath: initialPath.path)
        
        XCTAssertNotNil(migrator)
        
        guard let fileMigrator = migrator else { return }
        
        let unmigratable = fileMigrator.migrate()
                
        // Remove whitespace when comparing because it's irrelevant and seems to cause issues when comparing!

        XCTAssertEqual(
            fileMigrator.string.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil),
            finalString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
        )
        
        XCTAssertEqual(unmigratable[24], "<userDefinedRuntimeAttribute type=\"color\" keyPath=\"borderColor\">")
        XCTAssertEqual(unmigratable[33], "<userDefinedRuntimeAttribute type=\"color\" keyPath=\"shadowColor\">")
    }
}
