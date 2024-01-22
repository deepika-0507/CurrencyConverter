//
//  RemoteDataGatewayImpl.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 16/01/24.
//

import Foundation

class RemoteDataGatewayImpl: RemoteDataGateway {
    
    var service: APIService
    var localDB: CurrencyConverterDB
    
    init(service: APIService, localDB: CurrencyConverterDB) {
        self.service = service
        self.localDB = localDB
    }
    
    func getAvailableCurrencies() async -> Result<[String: String], CurrencyConverterErrors> {
        let currencies: Result<[String: String], CurrencyConverterErrors> = await service.fetchDataFromServer(endPoint: "currencies.json")
        switch currencies {
        case .success(let currencies):
            let _ = await localDB.updateData(value: currencies, fileSufix: "currencies")
            UserDefaults.standard.setValue(Date.now, forKey: "LastApiCallForCurrencies")
            return .success(currencies)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors> {
        let exchangeRatesResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = await service.fetchDataFromServer(endPoint: "latest.json?app_id=04dee88864924317891009ee29381a6b")
        switch exchangeRatesResult {
        case .success(let exchangeRates):
            let _ = await localDB.updateData(value: exchangeRates, fileSufix: "exchangeRates")
            UserDefaults.standard.setValue(Date.now, forKey: "LastApiCallForExchangeRates")
            return .success(exchangeRates)
        case .failure(let error):
            return .failure(error)
        }
    }
}
