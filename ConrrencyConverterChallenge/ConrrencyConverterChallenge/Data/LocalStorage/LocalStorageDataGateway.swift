//
//  LocalStorageDataGateway.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation

protocol LocalStorageDataGateway {
    func getCurrencies() async -> Result<[String: String], CurrencyConverterErrors>
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors>
}
