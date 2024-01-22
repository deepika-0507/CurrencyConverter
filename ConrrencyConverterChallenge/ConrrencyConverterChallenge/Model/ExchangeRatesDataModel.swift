//
//  ExchangeRatesDataModel.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 16/01/24.
//

import Foundation

class ExchangeRatesDataModel: Codable, Equatable {
    static func == (lhs: ExchangeRatesDataModel, rhs: ExchangeRatesDataModel) -> Bool {
        return lhs.base == rhs.base && lhs.rates == rhs.rates
    }
    
    let base: String
    let rates: [String: Double]
    
    init(base: String, rates: [String: Double])  {
        self.base = base
        self.rates = rates
    }
}
