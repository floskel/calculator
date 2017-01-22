//
//  CalculatorTest.swift
//  calculator
//
//  Created by Karlo Kristensen on 22/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import XCTest
@testable import calculator

class CalculatorTest: XCTestCase {
    var calculator = Calculator()
    var m : Calculator.Operation {
        get { return .binary(calculator.knownOps.first(where: { $0.symbol == "×" })!) }
    }
    
    var d : Calculator.Operation {
        get { return .binary(calculator.knownOps.first(where: { $0.symbol == "÷" })!) }
    }

    var a : Calculator.Operation {
        get { return .binary(calculator.knownOps.first(where: { $0.symbol == "+" })!) }
    }

    var s : Calculator.Operation {
        get { return .binary(calculator.knownOps.first(where: { $0.symbol == "−" })!) }
    }
    
    override func setUp() {
        super.setUp()
        
        calculator = Calculator()
    }
    
    func testAdding() {
        let expression = [Calculator.Operation.operand(value: 2), Calculator.Operation.operand(value: 2), a]
        XCTAssertTrue(calculator.evaluate(ops: expression).result == 4)
    }
    
    func testSubtraction() {
        let expression = [Calculator.Operation.operand(value: 5), Calculator.Operation.operand(value: 2), s]
        XCTAssertTrue(calculator.evaluate(ops: expression).result == 3)
    }
    
    func testMultiplication() {
        let expression = [Calculator.Operation.operand(value: 2), Calculator.Operation.operand(value: 3), m]
        XCTAssertTrue(calculator.evaluate(ops: expression).result == 6)
    }
    
    func testDivision() {
        let expression = [Calculator.Operation.operand(value: 3), Calculator.Operation.operand(value: 2), d]
        XCTAssertTrue(calculator.evaluate(ops: expression).result == 1.5)
    }
    
    func testAssociative() {
        
        let two = Calculator.Operation.operand(value: 2)
        let three = Calculator.Operation.operand(value: 3)
        let four = Calculator.Operation.operand(value: 4)
        
        let expression = [two, four, a, three, m] //(2+4)*3
        let result = calculator.evaluate(ops: expression).result
        XCTAssertTrue(result == 18)
    
        let expression2 = [two, four, m, three, a] //2*4+3
        let result2 = calculator.evaluate(ops: expression2).result
        XCTAssertTrue( result2 == 11)
        
        let expression3 = [two, four, three, m, a]
        let result3 = calculator.evaluate(ops: expression3).result
        XCTAssertTrue(result3 == 14)
    }
}
