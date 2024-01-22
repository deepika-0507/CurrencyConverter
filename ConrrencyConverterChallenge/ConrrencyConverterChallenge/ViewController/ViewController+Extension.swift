//
//  ViewController+Extension.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 17/01/24.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertedValues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let convertedValues else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRateTableViewCell", for: indexPath as IndexPath)
        var content = cell.defaultContentConfiguration()
        content.text = convertedValues.keys.map{$0}[indexPath.row] + " - " + String(format: "%.3f", convertedValues.values.map{$0}[indexPath.row])
        cell.contentConfiguration = content
        return cell
    }
    
    func setupTableView() {
        exchangeRatesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExchangeRateTableViewCell")
        exchangeRatesTableView.delegate = self
        exchangeRatesTableView.dataSource = self
    }
}
