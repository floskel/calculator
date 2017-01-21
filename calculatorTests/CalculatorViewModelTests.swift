//
//  CalculatorViewModelTests.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import XCTest
@testable import calculator

class CalculatorViewModelTests: XCTestCase {
    var viewModel : CalculatorViewModel = CalculatorViewModel()
    override func setUp() {
        super.setUp()
        viewModel = CalculatorViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHistory() {
        viewModel.input(2)
        viewModel.input("+")
        viewModel.input(2)
        XCTAssertTrue(viewModel.history == "2.0 + 2.0 ")
    }
    
    func testClear() {
        viewModel.input(2)
        viewModel.input("+")
        viewModel.input(2)
        viewModel.clear()
        XCTAssertTrue(viewModel.history == "")
    }
    
    func testDoubleDigitInput() {
        viewModel.input(1)
        
        XCTAssertFalse(viewModel.input(1))
    }
    
    func testFirstInput() {
        XCTAssertFalse(viewModel.input("*"))
    }
    
    func testDoubleOpInput() {
        viewModel.input(1)
        viewModel.input("*")
        XCTAssertFalse(viewModel.input("*"))
    }
    
    func testOnlyMathSymbols() {
        XCTAssertFalse(viewModel.input("&"))
        XCTAssertFalse(viewModel.input("#"))
        XCTAssertFalse(viewModel.input("@"))
    }
    
    func testResult() {
        viewModel.input(2)
        viewModel.input("+")
        viewModel.input(2)
        viewModel.calculate()
        XCTAssertTrue(viewModel.result == "4.0")
    }
    
    //TODO: Test all operations
}
