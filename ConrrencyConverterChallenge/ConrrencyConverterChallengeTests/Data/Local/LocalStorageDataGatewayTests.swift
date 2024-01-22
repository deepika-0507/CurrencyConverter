//
//  LocalStorageDataGatewayTests.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import XCTest
@testable import ConrrencyConverterChallenge

final class LocalStorageDataGatewayTests: XCTestCase {

    let localDB = MockCurrencyConverterDB()
    let testData = ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978])
    
    func testLocalStorageDataGateway_whenResultIsSuccesful_returnsData() async {
        let gateway = getLocalDBGatewayInstance()
        let dataResult = await gateway.getExchangeRates()
        switch dataResult {
        case .success(let data):
            XCTAssertEqual(data, testData)
        case .failure:
            XCTFail("Request should have passed")
        }
    }
    
    func testLocalStorageDataGateway_whenResultIsFailing_returnsError() async {
        let localStorageError = CurrencyConverterErrors.localStorageError(cause: "local storage error")
        let failureDB = MockCurrencyConverterDB(getDataResult: .failure(localStorageError))
        let gateway = LocalStorageDataGatewayImpl(localDB: failureDB)
        let dataResult = await gateway.getExchangeRates()
        switch dataResult {
        case .success:
            XCTFail("Request should have failed")
        case .failure(let error):
            XCTAssertEqual(error, localStorageError)
        }
    }
    
    private func getLocalDBGatewayInstance() -> LocalStorageDataGatewayImpl {
        return LocalStorageDataGatewayImpl(localDB: localDB)
    }

}
