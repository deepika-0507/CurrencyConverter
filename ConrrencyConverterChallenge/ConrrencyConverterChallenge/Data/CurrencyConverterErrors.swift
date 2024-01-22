//
//  CurrencyConverterErrors.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 16/01/24.
//

import Foundation

enum CurrencyConverterErrors: Error, Equatable {
    case networkError(cause: String)
    case localStorageError(cause: String)
    case convertionError(cause: String)
    
    var errorDescription: String {
        switch self {
        case .networkError(let cause):
            return cause
        case .localStorageError(let cause):
            return cause
        case .convertionError(let cause):
            return cause

        }
    }
}
