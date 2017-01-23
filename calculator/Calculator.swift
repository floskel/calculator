//
//  Calculator.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import Foundation

struct BinaryOperation {
    let symbol : String
    let precedence : Int
    let operation : (Double, Double) -> Double
}

class Calculator {
    
    enum Operation {
        case operand(value : Double)
        case binary(BinaryOperation)
        
        // Required number of operations needed to complete the calculation
        var valence : Int {
            switch self {
                case .operand: return 0
                case .binary: return 2
            }
        }
    }
    
    let knownOps : [BinaryOperation] = [
        BinaryOperation(symbol: "+", precedence: 2, operation: { $0 + $1 }),
        BinaryOperation(symbol: "−", precedence: 2, operation: { $1 - $0 }),
        BinaryOperation(symbol: "×", precedence: 3, operation: { $0 * $1 }),
        BinaryOperation(symbol: "÷", precedence: 3, operation: { $1 / $0 })
    ]
    
    func evaluate(ops : [Operation]) -> (result : Double?, remaining : [Operation]) {
        guard verify(ops: ops) else { return (nil, ops) }
        
        return calculate(ops: ops)
    }
    
    private func calculate(ops : [Operation]) -> (result : Double?, remaining : [Operation]) {
        var remainders = ops
        let op = remainders.removeLast()
        switch op {
        case .operand(let value):
            return (value, remainders)
        case .binary(let op):
            let response1 = calculate(ops: remainders)
            if let result1 = response1.result {
                let response2 = calculate(ops: response1.remaining)
                if let result2 = response2.result {
                    return (op.operation(result1, result2), response2.remaining)
                }
            }
        }
        return (nil, ops)
    }
    
    func verify(ops : [Operation]) -> Bool {
        guard !ops.isEmpty else { return false }
        
        var stackSize = 0
        for token in ops {
            stackSize += 1 - token.valence
            guard stackSize > 0 else {
                return false
            }
        }
        
        return stackSize == 1
    }
}
