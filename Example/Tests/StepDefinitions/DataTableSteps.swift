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
    
    var dataTableArray: [Int]?
    var sum: Int
    var dataTableDictionary: [[String: String]]?
    
    required init(test: XCTestCase) {
        self.dataTableArray = nil;
        self.sum = 0
        self.dataTableDictionary = nil;
        super.init(test: test)
    }
    
    override func defineSteps() {
        
        // Examples of defining a step with no capture groups
        step("A list of numbers") { (dataTable: [[String]]) in
            XCTAssertTrue(dataTable.count > 0)
            self.dataTableArray = dataTable.flatMap({ Int($0[0])! })
        }
        
        step("I sum them"){
            guard let dataTable = self.dataTableArray else {
                XCTFail("No data table available to sum")
                return
            }
            
            self.sum = dataTable.reduce(0, { $0 + $1 })
        }
        
        step("I should get ([0-9]+)") { (match:Int) in
            XCTAssertEqual(match, self.sum)
        }
        
        
        
        step("A set of translations") { (dataTable: [[String: String]]) in
            XCTAssertTrue(dataTable.count > 0)
            self.dataTableDictionary = dataTable
        }
        
        step("Latin name ([a-zA-Z0-9 ]*) should be translated to english name ([a-zA-Z0-9 ]*)") { (latinName: String, englishName: String) in
            guard let dataTable = self.dataTableDictionary else {
                XCTFail("No data table available for mapping")
                return
            }
            
            var mapping: [String: String]? = nil;
            for lineMapping in dataTable {
                if (lineMapping["Latin"] != latinName){
                    continue
                }
                
                mapping = lineMapping
                break
            }
            
            guard let translation = mapping else {
                XCTFail("No mapping found for given input")
                return
            }
            
            XCTAssertEqual(englishName, translation["English"])
        }
    }
}

