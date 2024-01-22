//
//  CurrencyConverterDB.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation

protocol CurrencyConverterDB {
    func getData<T: Codable>(fileSufix: String) async -> Result<T, CurrencyConverterErrors>
    func updateData<T: Codable>(value: T, fileSufix: String) async -> Result<Void, CurrencyConverterErrors>
}
