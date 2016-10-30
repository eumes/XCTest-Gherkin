//
//  DataTableSteps.swift
//  XCTest-Gherkin
//
//  Created by Simon on 10/29/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import XCTest_Gherkin

class SanityStepsDataTable : StepDefiner {
    
    var dataTable: [Int]?
    var sum: Int
    
    required init(test: XCTestCase) {
        self.dataTable = nil;
        self.sum = 0
        super.init(test: test)
    }
    
    override func defineSteps() {
        
        // Examples of defining a step with no capture groups
        step("A list of numbers") { (dataTable: [[String]]) in
            XCTAssertTrue(dataTable.count > 0)
            self.dataTable = dataTable.map { Int($0[0])!}
        }
        
        step("I sum them"){
            guard let dataTable = self.dataTable else {
                XCTFail("No data table available to sum")
                return
            }
            
            self.sum = dataTable.reduce(0, { $0 + $1 })
        }
        
        step("I should get ([0-9]+)") { (match:Int) in
            XCTAssertEqual(match, self.sum)
        }
    }
}

