//
//  Calculator.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import Foundation

typealias BinaryFunc = (Double, Double) -> Double

struct BinaryOperation {
    let symbol : String
    let precedence : Int
    let operation : BinaryFunc
}

class Calculator {
    
    enum Operation {
        case operand(Double)
        case binary(BinaryOperation)
    }
    
    let knownOps : [BinaryOperation] = [
        BinaryOperation(symbol: "+", precedence: 2, operation: { $0 + $1 }),
        BinaryOperation(symbol: "−", precedence: 2, operation: { $1 - $0 }),
        BinaryOperation(symbol: "×", precedence: 3, operation: { $0 * $1 }),
        BinaryOperation(symbol: "÷", precedence: 3, operation: { $1 / $0 })
    ]
    
    func evaluate(ops : [Operation]) -> (result : Double?, remaining : [Operation]) {
        if !ops.isEmpty {
            var remainders = ops
            let op = remainders.removeLast()
            switch op {
            case .operand(let value):
                return (value, remainders)
            case .binary(let op):
                let response1 = evaluate(ops: remainders)
                if let result1 = response1.result {
                    let response2 = evaluate(ops: response1.remaining)
                    if let result2 = response2.result {
                        return (op.operation(result1, result2), response2.remaining)
                    }
                }
            }
        }
        return (nil, ops)
    }
}
