//
//  CalculatorViewModel.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import Foundation

class CalculatorViewModel {
    
    enum Input {
        case digit(Double)
        case symbol(String)
    }
    
    private let calculator = Calculator()
    
    private var stack : [Calculator.Operation] = [] {
        didSet {
            updateHistory()
        }
    }
    
    var historyBind : ((String) -> ())?
    var history : String = "" {
        didSet {
            historyBind?(history)
        }
    }
    
    var resultBind : ((String) -> ())?
    var result : String = "" {
        didSet {
            resultBind?(result)
        }
    }
    
    @discardableResult
    private func input(from input : Input) -> Bool {
        guard let operation = verifiedOp(from: input) else { return false }
        stack.append(operation)
        return true
    }
    
    @discardableResult
    func input(_ inp : String) -> Bool {
        return input(from: .symbol(inp))
    }
    
    @discardableResult
    func input(_ inp : Double) -> Bool {
        return input(from: .digit(inp))
    }
    
    func clear() {
        stack = []
        result = ""
    }
    
    func calculate() {
        //Shunting yard algoritm. From infix -> RPN
        
        var operatorStack : [Calculator.Operation] = []
        var outputQueue : [Calculator.Operation] = []
        
        for token in stack {
            switch token {
            case .operand:
                outputQueue.append(token)
            case .binary(let o1):
                if case .binary(let o2)? = operatorStack.last {
                    if o1.precedence <= o2.precedence {
                        if let op = operatorStack.popLast() {
                            outputQueue.append(op)
                        }
                    }
                }
                operatorStack.append(token)
            }
        }
        
        while !operatorStack.isEmpty {
            guard let last = operatorStack.popLast() else { break }
            outputQueue.append(last)
        }
        
        if let res = calculator.evaluate(ops: outputQueue).result {
            result = "\(res)"
        }
    }
    
    private func updateHistory() {
        history = stack.reduce("") { (accumulator, operation) -> String in
            switch operation {
            case .operand(let value): return accumulator + "\(value) "
            case .binary(let op):   return accumulator + op.symbol + " "
            }
        }
    }
    
    private func verifiedOp(from input : Input) -> Calculator.Operation? {
        switch input {
        case .digit(let value):
            if case .operand? = stack.last {
                return nil
            }
            return Calculator.Operation.operand(value)
        case .symbol(let symbol):
            guard let last = stack.last else { return nil }
            if case .binary = last {
                return nil
            }
            guard let operation = calculator.knownOps.first(where: { $0.symbol == symbol }) else { return nil }
            return .binary(operation)
        }
    }
}
