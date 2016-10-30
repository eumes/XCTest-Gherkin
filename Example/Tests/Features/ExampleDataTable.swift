//
//  ExampleDataTable.swift
//  XCTest-Gherkin
//
//  Created by Simon on 10/29/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import XCTest_Gherkin

class ExampleDataTable: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ColorLog.enabled = true
    }
    
    let exampleDataTable = [
        ["17"],
        ["42"],
        ["4711"]
    ]
    
    func testDataTableVariant1() {
        Given("A list of numbers", exampleDataTable)
        When("I sum them")
        Then("I should get 4770");
    }
}
