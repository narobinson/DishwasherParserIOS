//
//  NetworkService.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//

import Foundation

protocol DishwasherService: class {
    
    func getDishwashers(completion: @escaping Handler)
}

class NetworkService: DishwasherService {
    
    private let url = "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    private let decoder = JSONDecoder()
    
    // - singleton
    static let shared = NetworkService()
    private init() { }
    
    func getDishwashers(completion: @escaping Handler){
        
        guard let productUrl = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: productUrl){ data, response, error in
            
            guard let serverData = data else {
                completion([])
                return
            }
            
            do {
                let result = try self.decoder.decode(DishwasherResponse.self, from: serverData)
                completion(result.products)
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
}
