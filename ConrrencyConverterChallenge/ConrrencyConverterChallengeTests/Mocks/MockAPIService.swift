//
//  MockAPIService.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation
@testable import ConrrencyConverterChallenge

class MockAPIService: APIService {
    
    let dataResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors>
    
    init(dataResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = .success(ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978]))) {
        self.dataResult = dataResult
    }
    
    func fetchDataFromServer<T>(endPoint: String) async -> Result<T, ConrrencyConverterChallenge.CurrencyConverterErrors> where T : Decodable, T : Encodable {
        dataResult as! Result<T, CurrencyConverterErrors>
    }
    
    
}
