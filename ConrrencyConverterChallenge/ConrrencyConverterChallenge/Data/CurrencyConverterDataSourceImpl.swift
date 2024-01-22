//
//  CurrencyConverterDataSourceImpl.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation

class CurrencyConverterDataSourceImpl: CurrencyConverterDataSource {
    
    var localDataSource: LocalStorageDataGateway
    var remoteDataSource: RemoteDataGateway
    
    init(localDataSource: LocalStorageDataGateway, remoteDataSource: RemoteDataGateway) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func getCurrencies() async -> Result<[String : String], CurrencyConverterErrors> {
        let lastApiCallTime = UserDefaults.standard.value(forKey: "LastApiCallForCurrencies") as? Date ?? Date.now
        let localCurrencicesResponse = await localDataSource.getCurrencies()
        switch localCurrencicesResponse {
        case .success(let currencies):
            if currencies.isEmpty || lastApiCallTime.isPastThirtyMinutes {
                return await remoteDataSource.getAvailableCurrencies()
            }
            return localCurrencicesResponse
        case .failure:
            return await remoteDataSource.getAvailableCurrencies()
        }
    }
    
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors> {
        let lastApiCallTime = UserDefaults.standard.value(forKey: "LastApiCallForExchangeRates") as? Date ?? Date.now
        let localExchangeRatesResponse = await localDataSource.getExchangeRates()
        switch localExchangeRatesResponse {
        case .success(let exchangeRates):
            if exchangeRates.rates.isEmpty || lastApiCallTime.isPastThirtyMinutes {
                return await remoteDataSource.getExchangeRates()
            }
            return localExchangeRatesResponse
        case .failure:
            return await remoteDataSource.getExchangeRates()
        }
    }
}
