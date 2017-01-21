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
    
    let viewModel = CalculatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.historyBind = { [unowned self] history in
            self.expression.text = history
        }
        
        viewModel.resultBind = { [unowned self] result in
            self.display.text = result
        }
    }
    
    var currentDisplay : String {
        get {
            return display.text ?? ""
        }
        set {
            display.text = newValue
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        viewModel.clear()
    }
    
    @IBAction func clearEntryTapped(_ sender: UIButton) {
        currentDisplay = ""
    }
    
    @IBAction func operatorTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        guard let currentDigit = Double(currentDisplay) else { return }
        
        viewModel.input(currentDigit)
        viewModel.input(title)
        
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
        print("equal")
        guard let currentDigit = Double(currentDisplay) else { return }
        viewModel.input(currentDigit)
        viewModel.calculate()
    }
}
