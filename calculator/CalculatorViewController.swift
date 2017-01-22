//
//  ViewController.swift
//  calculator
//
//  Created by Karlo Kristensen on 20/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UITextField!
    @IBOutlet weak var expression: UITextField!
    
    var viewModel : CalculatorViewModelType = CalculatorViewModelInfix() {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.expressionBind = { [unowned self] expression in
            self.expression.text = expression
        }
        //TODO: Test retaining
        viewModel.resultBind = { [unowned self] result in
            self.display.text = result
        }
    }
    
    var currentDisplay : String {
        get { return display.text ?? "" }
        set { display.text = newValue }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        viewModel.clear()
    }
    
    @IBAction func clearEntryTapped(_ sender: UIButton) {
        currentDisplay = ""
    }
    
    @IBAction func operatorTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        viewModel.add(input: currentDisplay)
        viewModel.add(input: title)
        currentDisplay = ""
    }
    
    @IBAction func digitTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        currentDisplay = currentDisplay + title
    }
    
    @IBAction func delimiterTapped(_ sender: UIButton) {
        guard !currentDisplay.contains(".") else { return }
        currentDisplay = currentDisplay + "."
    }
    
    @IBAction func equalTapped(_ sender: UIButton) {
        viewModel.add(input: currentDisplay)
        viewModel.calculate()
    }
}
