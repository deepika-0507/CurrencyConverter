//
//  CurrencyConverterDBImpl.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 16/01/24.
//

import Foundation

class CurrencyConverterDBImpl: CurrencyConverterDB {
    
    var prefixFileName = "currenct_converter_"
    
    func getData<T: Codable>(fileSufix: String) async -> Result<T, CurrencyConverterErrors> {
        do {
            let data: T = try await self.loadData(fileSufix: fileSufix)
            return .success(data)
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    func updateData<T: Codable>(value: T, fileSufix: String) async -> Result<Void, CurrencyConverterErrors> {
        do {
            try await self.saveData(value: value, fileSufix: fileSufix)
            return .success(())
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    // MARK: FileManager Methods
    
    private func fileURL(suffix: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(prefixFileName + suffix + ".data")
    }
    
    private func loadData<T: Codable>(fileSufix: String) async throws -> T {
        let fileUrl = try fileURL(suffix: fileSufix)
        do {
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    private func saveData<T: Codable>(value: T, fileSufix: String) async throws {
        let fileUrl = try fileURL(suffix: fileSufix)
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileUrl)
    }
}
