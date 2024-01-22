//
//  ViewModel.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 15/01/24.
//

import Foundation

class ViewModel {
    
    var dataSource: CurrencyConverterDataSource
    var currencies: [String: String]?
    var convertedExchangeRates: [String: Double] = [:]
    
    init(dataSource: CurrencyConverterDataSource) {
        self.dataSource = dataSource
    }
    
    func getCurrencies() async {
        let curenciesList = await dataSource.getCurrencies()
        switch curenciesList {
        case .success(let currencies):
            self.currencies = currencies
        case .failure(let error):
            print("error getting currencies data\(error.localizedDescription)")
        }
    }
    
    func getConvertedRates(for currency: String, amount: Double) async -> Result<[String: Double], CurrencyConverterErrors> {
        guard isValidAmount(amount) else {
            return .failure(.convertionError(cause: "Converstion amount is not valid"))
        }
        do {
            try await getExchangeRates(for: currency)
            var convertedRates: [String: Double] = [:]
            for exchangeCurrency in convertedExchangeRates.keys {
                let finalValue = (convertedExchangeRates[exchangeCurrency] ?? 0) * amount
                convertedRates[exchangeCurrency] = finalValue
            }
            return .success(convertedRates)
        } catch {
            return .failure(.convertionError(cause: error.localizedDescription))
        }
    }
    
    private func getExchangeRatesFromDataSource() async throws -> ExchangeRatesDataModel {
        let exchangeRates = await dataSource.getExchangeRates()
        switch exchangeRates {
        case .success(let rates):
            return rates
        case .failure(let error):
            throw error
        }
    }
    
    private func getExchangeRates(for currency: String) async throws {
        do {
            let exchangeRates = try await getExchangeRatesFromDataSource()
            let baseValue = exchangeRates.rates[currency] ?? 1
            var convertedExchangeRates: [String: Double] = [:]
            for i in exchangeRates.rates.keys {
                let convertedValue = (exchangeRates.rates[i] ?? 0) / baseValue
                convertedExchangeRates[i] = convertedValue
            }
            self.convertedExchangeRates = convertedExchangeRates
        } catch {
            throw error
        }
    }
    
    private func isValidAmount(_ amount: Double) -> Bool {
        return amount > 0
    }
    
}
