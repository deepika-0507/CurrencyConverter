//
//  CurrencyConverterDataSource.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation

protocol CurrencyConverterDataSource {
    func getCurrencies() async -> Result<[String:String], CurrencyConverterErrors>
    func getExchangeRates() async -> Result<ExchangeRatesDataModel, CurrencyConverterErrors>
}
