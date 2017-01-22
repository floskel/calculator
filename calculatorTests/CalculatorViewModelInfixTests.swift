//
//  CalculatorViewModelTests.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import XCTest
@testable import calculator

class CalculatorViewModelInfixTests: XCTestCase {
    var viewModel = CalculatorViewModelInfix()
    override func setUp() {
        super.setUp()
        viewModel = CalculatorViewModelInfix()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHistory() {
        viewModel.add(input: "2")
        viewModel.add(input: "+")
        viewModel.add(input: "2")
        XCTAssertTrue(viewModel.expression == "2.0 + 2.0")
    }
    
    func testClear() {
        viewModel.add(input: "2")
        viewModel.add(input: "+")
        viewModel.add(input: "2")
        viewModel.clear()
        XCTAssertTrue(viewModel.expression.isEmpty)
    }
    
    func testDoubleDigitInput() {
        viewModel.add(input: "1")
        XCTAssertFalse(viewModel.add(input: "1"))
    }
    
    func testFirstInput() {
        XCTAssertFalse(viewModel.add(input: "*"))
    }
    
    func testDoubleOpInput() {
        viewModel.add(input: "1")
        viewModel.add(input: "*")
        XCTAssertFalse(viewModel.add(input: "*"))
    }
    
    func testOnlyMathSymbols() {
        XCTAssertFalse(viewModel.add(input: "&"))
        XCTAssertFalse(viewModel.add(input: "#"))
        XCTAssertFalse(viewModel.add(input: "@"))
    }
    
    func testAdding() {
        viewModel.add(input: "2")
        viewModel.add(input: "+")
        viewModel.add(input: "2")
        viewModel.calculate()
        XCTAssertTrue(viewModel.expression == "2.0 + 2.0")
        XCTAssertTrue(viewModel.result == "4.0")
    }
    
    func testSubtraction() {
        viewModel.add(input: "2")
        viewModel.add(input: "−")
        viewModel.add(input: "1")
        viewModel.calculate()
        XCTAssertTrue(viewModel.expression == "2.0 − 1.0")
        XCTAssertTrue(viewModel.result == "1.0")
    }
    
    func testMultiplication() {
        viewModel.add(input: "2")
        viewModel.add(input: "×")
        viewModel.add(input: "3")
        XCTAssertTrue(viewModel.expression == "2.0 × 3.0")
        viewModel.calculate()
        XCTAssertTrue(viewModel.result == "6.0")
    }
    
    func testDivision() {
        viewModel.add(input: "3")
        viewModel.add(input: "÷")
        viewModel.add(input: "2")
        XCTAssertTrue(viewModel.expression == "3.0 ÷ 2.0")
        viewModel.calculate()
        XCTAssertTrue(viewModel.result == "1.5")
    }
    
    func testAssociative() {
        viewModel.add(input: "5")
        viewModel.add(input: "+")
        viewModel.add(input: "3")
        viewModel.add(input: "×")
        viewModel.add(input: "2")
        XCTAssertTrue(viewModel.expression == "5.0 + 3.0 × 2.0")
        viewModel.calculate()
        XCTAssertTrue(viewModel.result == "11.0")
    }
}
