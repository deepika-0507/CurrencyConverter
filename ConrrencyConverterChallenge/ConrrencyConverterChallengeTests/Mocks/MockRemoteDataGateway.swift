//
//  MockRemoteDataGateway.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation
@testable import ConrrencyConverterChallenge

class MockRemoteDataGateway: RemoteDataGateway {
    
    var currenciesResult: Result<[String : String], CurrencyConverterErrors>
    var exchangeRatesResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors>
    
    init(currenciesResult: Result<[String : String], CurrencyConverterErrors> = .success(["INR": "Indian Rupee", "USD": "US Dollar"]),
         exchangeRatesResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = .success(ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978]))) {
        self.currenciesResult = currenciesResult
        self.exchangeRatesResult = exchangeRatesResult
    }
    
    func getAvailableCurrencies() async -> Result<[String : String], CurrencyConverterErrors> {
        currenciesResult
    }
    
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors> {
        exchangeRatesResult
    }
    
}
