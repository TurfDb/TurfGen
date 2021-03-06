//
//  ModuleTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

let projectRoot = (((#file as NSString)
    .stringByDeletingLastPathComponent as NSString)
    .stringByDeletingLastPathComponent as NSString)
    .stringByDeletingLastPathComponent

class ModuleTests: XCTestCase {
    
    func testModuleNilInPathWithNoXcodeProject() {
        let pathWithNoXcodeProject = (#file as NSString).stringByDeletingLastPathComponent
        let model = Module(xcodeBuildArguments: [], name: nil, inPath: pathWithNoXcodeProject)
        XCTAssert(model == nil, "model initialization without any Xcode project should fail")
    }

    func testSourceKittenFrameworkDocsAreValidJSON() {
        let sourceKittenModule = Module(xcodeBuildArguments: ["-workspace", "SourceKitten.xcworkspace", "-scheme", "SourceKittenFramework"], name: nil, inPath: projectRoot)!
        let docsJSON = sourceKittenModule.docs.description
        XCTAssert(docsJSON.rangeOfString("error type") == nil)
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(docsJSON.dataUsingEncoding(NSUTF8StringEncoding)!, options: []) as? NSArray
            XCTAssertNotNil(jsonArray, "JSON should be propery parsed")
        } catch {
            XCTFail("JSON should be propery parsed")
        }
    }

    func testCommandantDocs() {
        let commandantPath = projectRoot + "/Carthage/Checkouts/Commandant/"
        let commandantModule = Module(xcodeBuildArguments: ["-workspace", "Commandant.xcworkspace", "-scheme", "Commandant"], name: nil, inPath: commandantPath)!
        let escapedCommandantPath = commandantPath.stringByReplacingOccurrencesOfString("/", withString: "\\/")
        let comparisonString = commandantModule.docs.description.stringByReplacingOccurrencesOfString(escapedCommandantPath, withString: "")
        let expected = File(path: fixturesDirectory + "Commandant.json")!.contents
        let actualDocsObject = try! NSJSONSerialization.JSONObjectWithData(comparisonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: []) as! NSArray
        let expectedDocsObject = try! NSJSONSerialization.JSONObjectWithData(expected.dataUsingEncoding(NSUTF8StringEncoding)!, options: []) as! NSArray
        XCTAssertEqual(actualDocsObject, expectedDocsObject, "should generate expected docs for Swift module")
    }
}
