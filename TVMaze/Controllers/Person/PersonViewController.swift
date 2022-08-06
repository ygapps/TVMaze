//
//  PersonViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/6/22.
//

import UIKit

class PersonViewController: UIViewController {

    private var personId: UInt
    private var viewModel: PersonViewModel

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let personCountryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var personViewButton: UIButton = {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.cornerStyle = .large // 2
        configuration.baseForegroundColor = .label
        configuration.buttonSize = .large
        configuration.title = "Visit Website"
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(visit(_:)), for: .touchUpInside)
        return button
    }()
    
    init(personId: UInt, viewModel: PersonViewModel) {
        self.viewModel = viewModel
        self.personId = personId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureLayout()
        configureViewModel()
    }

    private func configureViews() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(posterImageView)
        self.view.addSubview(personNameLabel)
        self.view.addSubview(personCountryLabel)
        self.view.addSubview(personViewButton)
    }
    
    private func configureLayout() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        personCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        personViewButton.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            posterImageView.widthAnchor.constraint(equalToConstant: 220),
            posterImageView.heightAnchor.constraint(equalToConstant: 220 * 1.5)
        ])
        
        NSLayoutConstraint.activate([
            personNameLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            personNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            personNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            personCountryLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 3.0),
            personCountryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            personCountryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            personViewButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16.0),
            personViewButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            personViewButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])

    }
    
    private func configureViewModel() {
        
        viewModel.didLoadPerson = { [weak self] in
            self?.personNameLabel.text = self?.viewModel.person?.personName
            self?.personCountryLabel.text = self?.viewModel.person?.personCountry?.name
            
            if let posterOriginalURL = self?.viewModel.person?.personImage?.original, let posterURL = URL(string: posterOriginalURL) {
                self?.posterImageView.sd_setImage(with: posterURL)
            }
        }
        
        viewModel.fetch(personId: personId)
    }
    
    // MARK: Actions
    
    @objc private func visit(_ sender: UIButton) {
        if let personURL = viewModel.person?.personURL, let mazeURL = URL(string: personURL) {
            UIApplication.shared.open(mazeURL, options: [:])
        }
    }
}
