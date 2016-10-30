//
//  StepDefiner.swift
//  whats-new
//
//  Created by Sam Dean on 29/10/2015.
//  Copyright © 2015 net-a-porter. All rights reserved.
//

import XCTest

/**
Classes which extend this class will be queried by the system to
populate the step definitions before test runs
*/
open class StepDefiner {
    open let test: XCTestCase
    
    required public init(test: XCTestCase) {
        self.test = test
    }
    
    /**
      Override this to create your own step definitions
     */
    open func defineSteps() -> Void { }

    
    // MARK: No matching group
    
    /**
     Create a new step with an expression that contains no matching groups.
         
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
         
         step("Some regular expression") {
             ... some function ...
         }
     
     - parameter expression: The expression to match against
     - parameter f0: The step definition to be run
     
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f0: @escaping ()->()) {
        self.test.addStep(expression, file: file, line: line) { (ignoredMatches:[String], ignoredDataTable:[[String]]?) in
            if let dataTable = ignoredDataTable {
                XCTFail("Step provided a data table but step definition did not expect one")
                return
            }
            
            f0()
        }
    }
    
    /**
     Create a new step with an expression that contains no matching groups and uses a data table
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some regular expression", dataTable) { (dataTable:[[String]]) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f0: The step definition to be run
     
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f0d: @escaping ([[String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (ignoredMatches:[String], requiredDataTable:[[String]]?) in
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            f0d(dataTable)
        }
    }

    
    open func step(_ expression: String, file: String = #file, line: Int = #line, f0dd: @escaping ([[String: String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (ignoredMatches:[String], requiredDataTable:[[String]]?) in
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            guard let dataTableDictionary = self.dataTableDictionaryFromArray(dataTable) else {
                XCTFail("Step expected data table dictionary but given data could not be converted")
                return
            }
            
            f0dd(dataTableDictionary)
        }
    }

    
    // MARK: One or more matching groups
    /**
     Create a new step with an expression that contains one or more matching groups.
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
         step("Some (regular|irregular) expression with a number ([0-9]*)") { (matches:[String]) in
             ... some function ...
         }
     
     - parameter expression: The expression to match against
     - parameter f1: The step definition to be run, passing in the matches from the expression
     
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1: @escaping ([String])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches:[String], ignoredDataTable:[[String]]?) in
            if let dataTable = ignoredDataTable {
                XCTFail("Step provided a data table but step definition did not expect one")
                return
            }
            
            f1(matches)
        }
    }
    
    /**
     Create a new step with an expression that contains one or more matching groups and uses a data table
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression with a number ([0-9]*)", dataTable) { (matches:[String], dataTable:[[String]]) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f1: The step definition to be run, passing in the matches from the expression
     
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1d: @escaping ([String], [[String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches:[String], requiredDataTable:[[String]]?) in
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            f1d(matches, dataTable)
        }
    }
    
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1dd: @escaping ([String], [[String: String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches:[String], requiredDataTable:[[String]]?) in
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            guard let dataTableDictionary = self.dataTableDictionaryFromArray(dataTable) else {
                XCTFail("Step expected data table dictionary but given data could not be converted")
                return
            }
            
            f1dd(matches, dataTableDictionary)
        }
    }
    
    
    // MARK: One matching group (string)
    /**
     If you only want to match the first parameter, this will help make your code nicer
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
         step("Some (regular|irregular) expression") { (match: String) in
             ... some function ...
         }
     
     - parameter expression: The expression to match against
     - parameter f1s: The step definition to be run, passing in the first capture group from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1s: @escaping (String)->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], ignoredDataTable: [[String]]?) in
            guard let match = matches.first else {
                XCTFail("Expected single match not found in \"\(expression)\"")
                return
            }
            
            if let dataTable = ignoredDataTable {
                XCTFail("Step provided a data table but step definition did not expect one")
                return
            }
            
            f1s(match)
        }
    }
    
    /**
     If you only want to match the first parameter, this will help make your code nicer. Also uses a data table.
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression", dataTable) { (match: String, dataTable:[[String]]) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f1s: The step definition to be run, passing in the first capture group from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1sd: @escaping (String, [[String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            guard let match = matches.first else {
                XCTFail("Expected single match not found in \"\(expression)\"")
                return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            f1sd(match, dataTable)
        }
    }
    
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1sdd: @escaping (String, [[String: String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            guard let match = matches.first else {
                XCTFail("Expected single match not found in \"\(expression)\"")
                return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            guard let dataTableDictionary = self.dataTableDictionaryFromArray(dataTable) else {
                XCTFail("Step expected data table dictionary but given data could not be converted")
                return
            }
            
            f1sdd(match, dataTableDictionary)
        }
    }
    
    
    // MARK: One matching group (int)
    /**
     If you only want to match the first parameter, this will help make your code nicer
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression") { (match: Int) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f1s: The step definition to be run, passing in the first capture group from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1i: @escaping (Int)->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], ignoredDataTable: [[String]]?) in
            guard let match = matches.first else {
                XCTFail("Expected single match not found in \"\(expression)\"")
                return
            }
            
            guard let integer = Int(match) else {
                XCTFail("Could not convert \"\(match)\" to an integer")
                return
            }
            
            if let dataTable = ignoredDataTable {
                XCTFail("Step provided a data table but step definition did not expect one")
                return
            }
            
            f1i(integer)
        }
    }
    
    /**
     If you only want to match the first parameter, this will help make your code nicer. Also uses a data table.
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression", dataTable) { (match: Int, dataTable:[[String]]) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f1s: The step definition to be run, passing in the first capture group from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1id: @escaping (Int, [[String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            guard let match = matches.first else {
                XCTFail("Expected single match not found in \"\(expression)\"")
                return
            }
            
            guard let integer = Int(match) else {
                XCTFail("Could not convert \"\(match)\" to an integer")
                return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            f1id(integer, dataTable)
        }
    }
    
    open func step(_ expression: String, file: String = #file, line: Int = #line, f1idd: @escaping (Int, [[String: String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            guard let match = matches.first else {
                XCTFail("Expected single match not found in \"\(expression)\"")
                return
            }
            
            guard let integer = Int(match) else {
                XCTFail("Could not convert \"\(match)\" to an integer")
                return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            guard let dataTableDictionary = self.dataTableDictionaryFromArray(dataTable) else {
                XCTFail("Step expected data table dictionary but given data could not be converted")
                return
            }
            
            f1idd(integer, dataTableDictionary)
        }
    }
    
    // MARK: Two matching groups (string)
    /**
     If you only want to match the first two parameters, this will help make your code nicer
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
         step("Some (regular|irregular) expression with a second capture group here (.*)") { (match1: String, match2: String) in
             ... some function ...
         }
     
     - parameter expression: The expression to match against
     - parameter f2s: The step definition to be run, passing in the first two capture groups from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f2s: @escaping (String, String)->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], ignoredDataTable: [[String]]?) in
            
            guard matches.count >= 2 else {
                XCTFail("Expected at least 2 matches, found \(matches.count) instead, from \"\(expression)\"")
                return
            }
            
            if let dataTable = ignoredDataTable {
                XCTFail("Step provided a data table but step definition did not expect one")
                return
            }
            
            f2s(matches[0], matches[1])
        }
    }
    
    /**
     If you only want to match the first two parameters, this will help make your code nicer. Also uses a data table.
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression with a second capture group here (.*)", dataTable) { (match1: String, match2: String, dataTable:[[String]]) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f2s: The step definition to be run, passing in the first two capture groups from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f2sd: @escaping (String, String, [[String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            
            guard matches.count >= 2 else {
                XCTFail("Expected at least 2 matches, found \(matches.count) instead, from \"\(expression)\"")
                return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            f2sd(matches[0], matches[1], dataTable)
        }
    }
    
    open func step(_ expression: String, file: String = #file, line: Int = #line, f2sdd: @escaping (String, String, [[String: String]])->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            
            guard matches.count >= 2 else {
                XCTFail("Expected at least 2 matches, found \(matches.count) instead, from \"\(expression)\"")
                return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            guard let dataTableDictionary = self.dataTableDictionaryFromArray(dataTable) else {
                XCTFail("Step expected data table dictionary but given data could not be converted")
                return
            }
            
            f2sdd(matches[0], matches[1], dataTableDictionary)
        }
    }
    
    
    // MARK: Two matching groups (int)
    /**
     If you only want to match the first parameters as integers, this will help make your code nicer
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression with a second capture group here (.*)") { (match1: Int, match2: Int) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f2i: The step definition to be run, passing in the first two capture groups from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f2i: @escaping (Int, Int)->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], ignoredDataTable: [[String]]?) in
            
            guard matches.count >= 2 else {
                XCTFail("Expected at least 2 matches, found \(matches.count) instead, from \"\(expression)\"")
                return
            }
            
            guard let i1 = Int(matches[0]),
                let i2 = Int(matches[1]) else {
                    XCTFail("Could not convert matches (\(matches[0]) and \(matches[1])) to integers, from \"\(expression)\"")
                    return
            }
            
            if let dataTable = ignoredDataTable {
                XCTFail("Step provided a data table but step definition did not expect one")
                return
            }
            
            f2i(i1, i2)
        }
    }
    
    /**
     If you only want to match the first parameters as integers, this will help make your code nicer. Also uses a data table.
     
     Don't pass anything for file: or path: - these will be automagically filled out for you. Use it like this:
     
     step("Some (regular|irregular) expression with a second capture group here (.*)") { (match1: Int, match2: Int) in
     ... some function ...
     }
     
     - parameter expression: The expression to match against
     - parameter f2i: The step definition to be run, passing in the first two capture groups from the expression
     */
    open func step(_ expression: String, file: String = #file, line: Int = #line, f2id: @escaping (Int, Int, [[String]]?)->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            
            guard matches.count >= 2 else {
                XCTFail("Expected at least 2 matches, found \(matches.count) instead, from \"\(expression)\"")
                return
            }
            
            guard let i1 = Int(matches[0]),
                let i2 = Int(matches[1]) else {
                    XCTFail("Could not convert matches (\(matches[0]) and \(matches[1])) to integers, from \"\(expression)\"")
                    return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            f2id(i1, i2, dataTable)
        }
    }
    
    open func step(_ expression: String, file: String = #file, line: Int = #line, f2idd: @escaping (Int, Int, [[String: String]]?)->()) {
        self.test.addStep(expression, file: file, line: line) { (matches: [String], requiredDataTable: [[String]]?) in
            
            guard matches.count >= 2 else {
                XCTFail("Expected at least 2 matches, found \(matches.count) instead, from \"\(expression)\"")
                return
            }
            
            guard let i1 = Int(matches[0]),
                let i2 = Int(matches[1]) else {
                    XCTFail("Could not convert matches (\(matches[0]) and \(matches[1])) to integers, from \"\(expression)\"")
                    return
            }
            
            guard let dataTable = requiredDataTable else {
                XCTFail("Step did not provide a data table but step defintition expected one")
                return
            }
            
            guard let dataTableDictionary = self.dataTableDictionaryFromArray(dataTable) else {
                XCTFail("Step expected data table dictionary but given data could not be converted")
                return
            }
            
            f2idd(i1, i2, dataTableDictionary)
        }
    }
    
    // MARK: Internal step calling
    /**
     Run other steps from inside your overridden defineSteps() method.
     
     Just do:
     
         step("Some Other Step")
     
     - parameter expression: A string which should match another step definition's regular expression

     */
    open func step(_ expression: String) {
        self.test.performStep(expression, nil)
    }
    
    /**
     Run other steps from inside your overridden defineSteps() method.
     
     Just do:
     
     step("Some Other Step")
     
     - parameter expression: A string which should match another step definition's regular expression
     
     */
    open func step(_ expression: String, dataTable: [[String]]) {
        self.test.performStep(expression, dataTable)
    }
    
    
    func dataTableDictionaryFromArray(_ dataTable: [[String]]) -> [[String: String]]?{
        if (dataTable.count < 2){
            return nil;
        }
        
        var mappings: [[String: String]] = []
        var dataTableArray = dataTable;
        let names = dataTableArray.removeFirst()
        for line in dataTableArray {
            var mapping: [String: String] = [:]
            for (index, element) in line.enumerated() {
                mapping.updateValue(element, forKey: names[index])
            }
            mappings.append(mapping)
        }
        
        return mappings
    }
}
