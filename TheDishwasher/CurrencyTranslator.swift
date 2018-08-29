//
//  CurrencyTranslator.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//
import Foundation

class CurrencyTranslator {
    
    static func translate(_ cash: Double) -> String? {
        
        print(Locale.current) // en_GB --- tells what language and region code for phone
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: cash))

    }
}
