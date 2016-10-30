//
//  ExampleNativeDataTable.swift
//  XCTest-Gherkin
//
//  Created by Simon on 10/30/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//


import XCTest
import XCTest_Gherkin

class ExampleNativeDataTable : NativeTestCase {
    override class func path() -> URL? {
        let bundle = Bundle(for: self)
        return bundle.resourceURL?.appendingPathComponent("NativeFeatures/native_example_datatable.feature")
    }
    
    override func setUp() {
        super.setUp()
        ColorLog.enabled = true
    }
}
