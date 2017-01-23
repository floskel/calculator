//
//  ExpressionsViewController.swift
//  calculator
//
//  Created by Karlo Kristensen on 22/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import UIKit

// Expressions
// Displays saved expressions provided from the view model

class ExpressionsViewController : UIViewController {
    fileprivate let tableView = UITableView()
    
    fileprivate let viewModel = ExpressionsViewModel()
    
    override func loadView() {
        view = tableView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ExpressionsViewController.close))
        
        navigationItem.title = "Saved expressions"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }
    
    func close() {
        parent?.dismiss(animated: true)
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension ExpressionsViewController : Reloadable {
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ExpressionsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expressions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.expressions[indexPath.row]
        return cell
    }
}
