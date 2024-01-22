//
//  APIServiceImpl.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 13/01/24.
//

import Foundation

class APIServiceImpl: APIService {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchDataFromServer<T: Codable>(endPoint: String) async -> Result<T, CurrencyConverterErrors> {
        guard let url = URL(string: "https://openexchangerates.org/api/" + endPoint) else {
            return .failure(.networkError(cause: "Error generting url from string"))
        }
        do {
            let (data, response) = try await urlSession.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return .failure(.networkError(cause: "Status code is not 200"))
            }
            let decodeData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodeData)
        } catch {
            return .failure(.networkError(cause: "Error decoding data"))
        }
    }
    
}
