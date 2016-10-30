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
    
    let exampleData2 = [
        ["Latin",           "English"],
        ["Cucumis sativus", "Cucumber"],
        ["Cucumis anguria", "Burr Gherkin"]
    ]
    
    func testDataTableVariant2() {
        Given("A set of translations", exampleData2)
        Then("Latin name Cucumis sativus should be translated to english name Cucumber")
    }
}
