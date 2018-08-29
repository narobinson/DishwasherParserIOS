//
//  FacadeService.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//

import Foundation
import Reachability

typealias Handler = ([Dishwasher]) -> Void

final class FacadeService {
    
    static let shared = FacadeService()
    
    private let remoteService: DishwasherService = NetworkService.shared
    private let localService = CoreDataService()
    
    private let reachability = Reachability(hostName: API.host)!
    
    private init() { }
    
    func getDishwashers(completion: @escaping Handler){
        
        switch reachability.currentReachabilityStatus() {

        case .ReachableViaWiFi, .ReachableViaWWAN:
            // - network reachable via WIFI or Data
            print("Network reachable, fetching remote data")
            getRemoteDiswashers(completion: completion)

        case .NotReachable:
            // - network not reachable
            print("No network, trying locally")
            self.localService.getDishwashers(completion: completion)
        }
    }
    
    private func getRemoteDiswashers(completion: @escaping Handler){
        remoteService.getDishwashers(){ dishwashers in
            self.save(dishwashers: dishwashers)
            completion(dishwashers)
        }
    }
    
    /**
        Save to Core Data
     */
    private func save(dishwashers: [Dishwasher]){
        localService.save(diswashers: dishwashers)
    }
}
