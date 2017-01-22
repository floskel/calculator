//
//  CalculatorViewModel.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

protocol CalculatorViewModelType {
    var expression : String { get set }
    var expressionBind : ((String) -> ())? { get set }
    
    var result : String { get set }
    var resultBind : ((String) -> ())? { get set }
    
    @discardableResult
    func add(input : String) -> Bool
    
    func clear()
    func calculate()
}

class CalculatorViewModelInfix : CalculatorViewModelType {
    private let calculator = Calculator()
    
    private var stack : [Calculator.Operation] = [] {
        didSet {
            expression = stack.map({ (op) -> String in
                switch op {
                case .operand(let value): return "\(value)"
                case .binary(let op):   return op.symbol
                }
            }).joined(separator: " ")
        }
    }
    
    var expressionBind : ((String) -> ())?
    var expression : String = "" {
        didSet { expressionBind?(expression) }
    }
    
    var resultBind : ((String) -> ())?
    var result : String = "" {
        didSet { resultBind?(result) }
    }
    
    @discardableResult
    func add(input: String) -> Bool {
        if let digit = Double(input) {
            guard let digitOp = verifiedDigitOp(from: digit) else { return false }
            stack.append(digitOp)
            return true
        } else {
            guard let symbolOp = verifiedSymbolOp(from: input) else { return false }
            stack.append(symbolOp)
            return true
        }
    }
    
    func clear() {
        stack = []
        result = ""
    }
    
    func calculate() {
        //Shunting yard algoritm. From infix -> RPN
        
        var operators : [Calculator.Operation] = []
        var output : [Calculator.Operation] = []
        
        for token in stack {
            switch token {
            case .operand:
                output.append(token)
            case .binary(let o1):
                if case .binary(let o2)? = operators.last {
                    if o1.precedence <= o2.precedence {
                        if let op = operators.popLast() {
                            output.append(op)
                        }
                    }
                }
                operators.append(token)
            }
        }
        
        while !operators.isEmpty {
            guard let last = operators.popLast() else { break }
            output.append(last)
        }
        
        if let res = calculator.evaluate(ops: output).result {
            result = "\(res)"
        }
    }
    
    private func verifiedDigitOp(from value : Double) -> Calculator.Operation? {
        if case .operand? = stack.last {
            return nil
        }
        return Calculator.Operation.operand(value: value)
    }
    
    private func verifiedSymbolOp(from symbol : String) -> Calculator.Operation? {
        
        guard let last = stack.last else { return nil }
        
        if case .binary = last {
            return nil
        }
        guard let operation = calculator.knownOps.first(where: { $0.symbol == symbol }) else { return nil }
        
        return .binary(operation)
    }
}
