//
//  DataGatewayTests.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import XCTest
@testable import ConrrencyConverterChallenge

final class DataGatewayTests: XCTestCase {

    let mocklocalDataSource = MockLocalStorageDataGateway()
    let mockRemoteDataSouce = MockRemoteDataGateway()
    let testData = ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978])
    let localTestData = ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.73, "INR": 56.895, "DOL": 3.978])
    let localError = CurrencyConverterErrors.localStorageError(cause: "local error")
    let networkError = CurrencyConverterErrors.networkError(cause: "network error")
    
    func getDataGatewayInstance() -> CurrencyConverterDataSource {
        return CurrencyConverterDataSourceImpl(localDataSource: mocklocalDataSource,
                                               remoteDataSource: mockRemoteDataSouce)
    }
    
    func testDataGateway_whenResultIsSuccessful_returnsData() async {
        let gateway = getDataGatewayInstance()
        let dataResult = await gateway.getExchangeRates()
        
        switch dataResult {
        case .success(let exchangeRates):
            XCTAssertEqual(exchangeRates, testData)
        case .failure:
            XCTFail("Request should have successful")
        }
    }
    
    func testDateGateway_whenLocalResultFails_returnsResponseFromRemote() async {
        let failedLocalDataSource = MockLocalStorageDataGateway(exchangeRatesResult: .failure(localError))
        let gateway = CurrencyConverterDataSourceImpl(localDataSource: failedLocalDataSource,
                                                      remoteDataSource: mockRemoteDataSouce)
        let dataResult = await gateway.getExchangeRates()
        
        switch dataResult {
        case .success(let exchangeRates):
            XCTAssertEqual(exchangeRates, testData)
        case .failure:
            XCTFail("Request should have successful")
        }
    }
    
    func testDataGateway_whenLocalResultIsEmpty_returnsResponseFromRemote() async {
        let emptyRates = ExchangeRatesDataModel(base: "USD", rates: [:])
        let localDataSource = MockLocalStorageDataGateway(exchangeRatesResult: .success(emptyRates))
        let gateway = CurrencyConverterDataSourceImpl(localDataSource: localDataSource,
                                                      remoteDataSource: mockRemoteDataSouce)
        
        let dataResult = await gateway.getExchangeRates()
        
        switch dataResult {
        case .success(let exchangeRates):
            XCTAssertEqual(exchangeRates, testData)
        case .failure:
            XCTFail("Request should have successful")
        }
    }
    
    func testDataGateway_whenBothResultFails_returnError() async {
        let localDataSource = MockLocalStorageDataGateway(exchangeRatesResult: .failure(localError))
        let remoteDataSource = MockRemoteDataGateway(exchangeRatesResult: .failure(networkError))
        let gateway = CurrencyConverterDataSourceImpl(localDataSource: localDataSource,
                                                      remoteDataSource: remoteDataSource)
        
        let dataResult = await gateway.getExchangeRates()
        
        switch dataResult {
        case .success:
            XCTFail("Request should have failed")
        case .failure(let error):
            XCTAssertEqual(error, networkError)
        }
    }

}
