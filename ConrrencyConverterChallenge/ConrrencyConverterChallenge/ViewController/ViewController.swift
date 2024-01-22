//
//  ViewController.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 11/01/24.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the currency from the list and enter the amount."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .firstBaseline
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Enter the amount"
        return view
    }()
    
    lazy var convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("Convert", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(convertTheCurrency), for: .touchUpInside)
        return button
    }()
    
    lazy var exchangeRatesTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var errorMessageView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var currenciesList: [String: String]?
    var viewModel: ViewModel
    var selectedCurrency = "AED"
    
    var convertedValues: [String: Double]? {
        didSet {
            exchangeRatesTableView.reloadData()
        }
    }
    
    var errorMessage: String? {
        didSet {
            addErrorMessageview()
        }
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task(priority: .high) {
            await viewModel.getCurrencies()
            await MainActor.run {
                self.currenciesList = viewModel.currencies
                stackView.addArrangedSubview(createMenuView())
                stackView.addArrangedSubview(textField)
           }
        }
        
        self.view.backgroundColor = .white
        self.view.addSubview(textLabel)
        self.view.addSubview(stackView)
        self.view.addSubview(convertButton)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            textLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            convertButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            convertButton.heightAnchor.constraint(equalToConstant: 50),
            convertButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            convertButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
        
        self.addTableView()
    }
    
    func addErrorMessageview() {
        exchangeRatesTableView.removeFromSuperview()
        errorMessageView.text = errorMessage
        self.view.addSubview(errorMessageView)
        NSLayoutConstraint.activate([
            errorMessageView.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 16),
            errorMessageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            errorMessageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    func addTableView() {
        errorMessageView.removeFromSuperview()
        self.setupTableView()
        self.view.addSubview(exchangeRatesTableView)
        
        NSLayoutConstraint.activate([
            exchangeRatesTableView.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 16),
            exchangeRatesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exchangeRatesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exchangeRatesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createMenuView() -> UIView {
        guard let currencies = currenciesList else { return UIView() }
        var currencyMenu: [UIMenuElement] = []
        
        for currency in currencies.keys.sorted() {
            currencyMenu.append(UIAction(title: currency, handler: { action in
                self.selectedCurrency = action.title
            }))
        }
        
        let button = UIButton(primaryAction: nil)
        
        button.menu = UIMenu(options: .displayInline, children: currencyMenu)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        return button
    }
    
    @objc func convertTheCurrency() {
        Task {
            let convertedValuesResult = await viewModel.getConvertedRates(for: selectedCurrency, amount: Double(textField.text ?? "") ?? 0.0)
            switch convertedValuesResult {
            case .success(let convertedValues):
                self.convertedValues = convertedValues
                self.addTableView()
            case .failure(let error):
                self.errorMessage = error.errorDescription
            }
        }
    }
}

