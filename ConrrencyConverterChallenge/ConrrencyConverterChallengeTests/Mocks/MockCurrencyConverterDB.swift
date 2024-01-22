//
//  MockCurrencyConverterDB.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation
@testable import ConrrencyConverterChallenge

class MockCurrencyConverterDB: CurrencyConverterDB {
    var getDataResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors>
    let updateDataResult: Result<Void, CurrencyConverterErrors>
    
    let mockExchangeRate = ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978])
    
    init(
        getDataResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = .success(ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978])),
        updateDataResult: Result<Void, CurrencyConverterErrors> = .success(())
    ) {
        self.getDataResult = getDataResult
        self.updateDataResult = updateDataResult
    }
        
    func getData<T: Codable>(fileSufix: String) async -> Result<T, CurrencyConverterErrors> {
        getDataResult as! Result<T, CurrencyConverterErrors>
    }
    
    func updateData<T: Codable>(value: T, fileSufix: String) async -> Result<Void, CurrencyConverterErrors> {
        updateDataResult
    }
    
    
}
