//
//  RemoteDataGatewayTests.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import XCTest
@testable import ConrrencyConverterChallenge

final class RemoteDataGatewayTests: XCTestCase {

    let apiService = MockAPIService()
    let localDB = MockCurrencyConverterDB()
    let testData = ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978])
    
    func getRemoteDataGateWayInstance() -> RemoteDataGateway {
        return RemoteDataGatewayImpl(service: apiService, localDB: localDB)
    }
    
    func testRemoteDataGateway_whenResultIsSuccessful_returnsData() async {
        let gateway = getRemoteDataGateWayInstance()
        let dataResult = await gateway.getExchangeRates()
        switch dataResult {
        case .success(let exchangeRates):
            XCTAssertEqual(exchangeRates, testData)
        case .failure:
            XCTFail("Request should have successful")
        }
    }
    
    func testRemoteDataGateway_whenResultIsFailure_returnsError() async {
        let remoteError = CurrencyConverterErrors.networkError(cause: "network error")
        let failureAPIService = MockAPIService(dataResult: .failure(remoteError))
        let gateway = RemoteDataGatewayImpl(service: failureAPIService, localDB: localDB)
        let dataResult = await gateway.getExchangeRates()
        
        switch dataResult {
        case .success:
            XCTFail("Request should have failed")
        case .failure(let error):
            XCTAssertEqual(error, remoteError)
        }
    }
    
    func testRemoteDataGateway_whenResultIsSuccessful_updateDataInLocal() async {
        let mockDB = MockCurrencyConverterDB(updateDataResult: .success(()))
        let gateway = RemoteDataGatewayImpl(service: apiService, localDB: mockDB)
        let dataResult = await gateway.getExchangeRates()
        
        switch dataResult {
        case .success:
            let _ = await mockDB.updateData(value: testData, fileSufix: "exchangeRates")
            let result: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = await mockDB.getData(fileSufix: "exchangeRates")
            switch result {
            case .success(let value):
                XCTAssertEqual(value, testData)
            case .failure:
                XCTFail("Request should have successful")
            }
        case .failure:
            XCTFail("Request should have successful")
        }
    }
}
