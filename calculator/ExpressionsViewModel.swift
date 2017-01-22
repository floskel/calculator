//
//  ExpressionsViewModel.swift
//  calculator
//
//  Created by Karlo Kristensen on 22/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//


protocol Reloadable : class {
    func reload()
}

class ExpressionsViewModel {
    var expressions : [String] = []
    private let programAPI = ProgramService()
    
    weak var delegate : Reloadable?
    
    init() {
        programAPI.allPrograms { [unowned self] (programs) in
            guard let programs = programs else { return }
            self.expressions = programs.flatMap({ $0.expression })
            self.delegate?.reload()
        }
    }
}
