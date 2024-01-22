//
//  LocalStorageDataGatewayImpl.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 16/01/24.
//

import Foundation

class LocalStorageDataGatewayImpl: LocalStorageDataGateway {
    
    var localDB: CurrencyConverterDB
    
    init(localDB: CurrencyConverterDB) {
        self.localDB = localDB
    }
    
    func getCurrencies() async -> Result<[String: String], CurrencyConverterErrors> {
        await localDB.getData(fileSufix: "currencies")
    }
    
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors> {
        await localDB.getData(fileSufix: "exchangeRates")
    }
}
