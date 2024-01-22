//
//  APIService.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import Foundation

protocol APIService {
    func fetchDataFromServer<T: Codable>(endPoint: String) async -> Result<T, CurrencyConverterErrors>
}
