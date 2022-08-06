//
//  PINViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/6/22.
//

import UIKit


class PINViewController: UIViewController {
    private weak var coordinator: PINCoordinator? // Retain Cycle Avoidance

    private lazy var generatePINButton: UIButton = {
        var configuration = UIButton.Configuration.bordered() // 1
        configuration.cornerStyle = .large // 2
        configuration.baseForegroundColor = .label
        configuration.buttonSize = .large
        configuration.title = "Add PIN"
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(addPIN(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var removePINButton: UIButton = {
        var configuration = UIButton.Configuration.bordered() // 1
        configuration.cornerStyle = .large // 2
        configuration.baseForegroundColor = .label
        configuration.buttonSize = .large
        configuration.title = "Remove PIN"
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(removePIN(_:)), for: .touchUpInside)
        return button
    }()
    
    init(coordinator: PINCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureLayout()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.title = "PIN"
        
        view.addSubview(generatePINButton)
        view.addSubview(removePINButton)
    }
    
    private func configureLayout() {
        generatePINButton.translatesAutoresizingMaskIntoConstraints = false
        removePINButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            generatePINButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            generatePINButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            generatePINButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
        ])
        
        NSLayoutConstraint.activate([
            removePINButton.topAnchor.constraint(equalTo: generatePINButton.bottomAnchor, constant: 16.0),
            removePINButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            removePINButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
        ])
    }
    
    // MARK: Actions
    
    @objc private func addPIN(_ sender: UIButton) {
        coordinator?.showPIN()
    }
    
    @objc private func removePIN(_ sender: UIButton) {
        coordinator?.removePIN()
    }
}
