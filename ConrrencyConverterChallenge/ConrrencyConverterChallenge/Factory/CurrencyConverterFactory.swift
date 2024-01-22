//
//  CurrencyConverterFactory.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 16/01/24.
//

import UIKit

class CurrencyConverterFactory {
    func makeViewController() -> UIViewController {
        let apiService = APIServiceImpl()
        let currencyDB = CurrencyConverterDBImpl()
        let remoteDataSource = RemoteDataGatewayImpl(service: apiService, localDB: currencyDB)
        let localDataSource = LocalStorageDataGatewayImpl(localDB: currencyDB)
        let dataSource = CurrencyConverterDataSourceImpl(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        let viewModel = ViewModel(dataSource: dataSource)
        let viewController = ViewController(viewModel: viewModel)
        return viewController
    }
}
