//
//  ProgramsService.swift
//  calculator
//
//  Created by Karlo Kristensen on 22/01/2017.
//  Copyright © 2017 Floskel. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

struct Program {
    let expression : String
    
    init?(json : JSON) {
        guard let expression = json["expression"] as? String else { return nil }
        self.expression = expression
    }
}

class ProgramService {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let baseURL = URL(string: "https://vast-retreat-57134.herokuapp.com/programs")!
    
    func allPrograms(completion: @escaping ([Program]?) -> Void) {
        let request = URLRequest(url: baseURL)
        session.dataTask(with: request) { (data, response, err) in
            guard
                err == nil,
                response?.isSuccess ?? false,
                let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let json = jsonData as? [JSON]
            else {
                completion(nil)
                return
            }
            
            let programs = json.flatMap({
                return Program(json: $0)
            })
            
            completion(programs)
            
            
        }.resume()
    }
    
    func createProgram(expression : String, completion : @escaping (Program?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: ["expression" : expression], options: [])
        
        session.dataTask(with: request) { (data, response, err) in
            guard
                err == nil,
                response?.isSuccess ?? false,
                let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let json = jsonData as? JSON
            else {
                completion(nil)
                return
            }
            
            completion(Program(json: json))
        }.resume()
        
    }
}

extension URLResponse {
    var isSuccess : Bool {
        guard let response = self as? HTTPURLResponse else { return false }
        return (200...299).contains(response.statusCode)
    }
}
