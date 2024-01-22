//
//  APIServiceTests.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import XCTest
@testable import ConrrencyConverterChallenge

final class APIServiceTests: XCTestCase {
    
    let testData = ExchangeRatesDataModel(base: "USD", rates: ["AED": 2.7893, "INR": 56.895, "DOL": 3.978])

    func testAPIService_whenFetchingDataFromServer_returnsResult() async {
        let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=04dee88864924317891009ee29381a6b")!
        let encodedTestData = try? JSONEncoder().encode(testData)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        URLProtocolStub.stub(data: encodedTestData, response: urlResponse, error: nil)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let urlSession = URLSession(configuration: configuration)
        let serviceInstance = APIServiceImpl(urlSession: urlSession)
        
        let dataResult: Result<ExchangeRatesDataModel, CurrencyConverterErrors> = await serviceInstance.fetchDataFromServer(endPoint: "latest.json?app_id=04dee88864924317891009ee29381a6b")
        
        switch dataResult {
        case .success(let exchangeRates):
            XCTAssertEqual(exchangeRates, testData)
        case .failure:
            XCTFail("Request should have passed")
        }
        
    }
}
