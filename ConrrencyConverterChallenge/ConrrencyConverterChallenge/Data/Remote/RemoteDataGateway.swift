//
//  RemoteDataGateway.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation

protocol RemoteDataGateway {
    func getAvailableCurrencies() async -> Result<[String: String], CurrencyConverterErrors>
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors>
}
