//
//  MockCurrencyConverterDataSource.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation
@testable import ConrrencyConverterChallenge

class MockCurrencyConverterDataSource: CurrencyConverterDataSource {
    
    var currencyResult: Result<[String : String], CurrencyConverterErrors>
    var exchangeRatesResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors>
    
    init(currencyResult: Result<[String : String], CurrencyConverterErrors> = .success(["INR": "Indian Rupee", "USD": "US Dollar"]),
         exchangeRatesResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = .success(ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978]))) {
        self.currencyResult = currencyResult
        self.exchangeRatesResult = exchangeRatesResult
    }
    
    
    func getCurrencies() async -> Result<[String : String], CurrencyConverterErrors> {
        currencyResult
    }
    
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors> {
        exchangeRatesResult
    }
    
    
}
