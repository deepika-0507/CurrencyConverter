//
//  ViewModelTests.swift
//  ConrrencyConverterChallengeTests
//
//  Created by Deepika Ponnaganti on 18/01/24.
//

import XCTest
@testable import ConrrencyConverterChallenge

final class ViewModelTests: XCTestCase {

    let mockDataSource = MockCurrencyConverterDataSource()
    let currenciesTestData = ["INR": "Indian Rupee", "USD": "US Dollar"]
    let exchangeRatesWithoutChange = ["AED": 2.7893, "INR": 56.895, "DOL": 3.978]
    
    func makeViewModelInstance() -> ViewModel {
        return ViewModel(dataSource: mockDataSource)
    }
    
    func testViewModel_whenfetchingCurrenciesResultIsSuccessful_returnsData() async {
        let viewModel = makeViewModelInstance()
        
        await viewModel.getCurrencies()
        XCTAssertEqual(viewModel.currencies, currenciesTestData)
    }
    
    func testViewModel_whenUserEnterAmountIsNotValid_returnError() async {
        let viewModel = makeViewModelInstance()
        
        let dataResult = await viewModel.getConvertedRates(for: "USD", amount: -346.7872)
        
        switch dataResult {
        case .success:
            XCTFail("Request should have failed")
        case .failure(let error):
            XCTAssertEqual(error, CurrencyConverterErrors.convertionError(cause: "Converstion amount is not valid"))
        }
    }
    
    func testViewModel_whenUnKnownCurrencyISSelected_returnsDataWithoutChange() async {
        let viewModel = makeViewModelInstance()
        let dataResult = await viewModel.getConvertedRates(for: "#$@", amount: 1.0)
        
        switch dataResult {
        case .success(let exchangeRates):
            XCTAssertEqual(exchangeRates, exchangeRatesWithoutChange)
        case .failure:
            XCTFail("Request should have successful")
        }
    }
}
