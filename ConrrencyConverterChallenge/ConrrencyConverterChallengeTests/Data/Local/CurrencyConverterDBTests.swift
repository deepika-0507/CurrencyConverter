//
//  CurrencyConverterDBTests.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import XCTest
@testable import ConrrencyConverterChallenge

final class CurrencyConverterDBTests: XCTestCase {

    let sampleValue = ["AED": 2.7893, "INR": 56.895, "DOL": 3.978]
    let mockDB = CurrencyConverterDBImpl()
    
    func testCurrencyConverterDB_whenRequestingDataInitially_getEmptyData() async {
        let dataResult: Result<[String: String], CurrencyConverterErrors> = await mockDB.getData(fileSufix: "sample")
        switch dataResult {
        case .success:
            XCTFail("Requesd should have failed")
        case .failure(let error):
            XCTAssertEqual(error, CurrencyConverterErrors.localStorageError(cause: error.errorDescription))
        }
    }
    
    func testCurrencyConverterDB_whenUpdatingData_saveDataInFile() async {
        let _ = await mockDB.updateData(value: sampleValue, fileSufix: "exchangeRates")
        let dataResult: Result<[String: Double], CurrencyConverterErrors> = await mockDB.getData(fileSufix: "exchangeRates")
        
        switch dataResult {
        case .success(let success):
            XCTAssertEqual(success, sampleValue)
        case .failure:
            XCTFail("Request should have succeeded")
        }
        
    }
}
