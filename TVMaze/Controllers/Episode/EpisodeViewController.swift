//
//  EpisodeViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import UIKit

class EpisodeViewController: UIViewController {

    private var episodeId: UInt
    private var viewModel: EpisodeViewModel

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let episodeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let episodeSeasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let episodeSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 20
        return label
    }()
    
    init(episodeId: UInt, viewModel: EpisodeViewModel) {
        self.viewModel = viewModel
        self.episodeId = episodeId
        
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
        self.view.addSubview(episodeNameLabel)
        self.view.addSubview(episodeSeasonLabel)
        self.view.addSubview(episodeSummaryLabel)
    }
    
    private func configureLayout() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        episodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeSeasonLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
 
    
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            posterImageView.widthAnchor.constraint(equalToConstant: 220),
            posterImageView.heightAnchor.constraint(equalToConstant: 220 / 1.778)
        ])
        
        NSLayoutConstraint.activate([
            episodeNameLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            episodeNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            episodeNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            episodeSeasonLabel.topAnchor.constraint(equalTo: episodeNameLabel.bottomAnchor, constant: 3.0),
            episodeSeasonLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            episodeSeasonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            episodeSummaryLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16.0),
            episodeSummaryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            episodeSummaryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])

    }
    
    private func configureViewModel() {
        viewModel.didLoadEpisode = { [weak self] in
            self?.episodeNameLabel.text = self?.viewModel.episode?.episodeName
            self?.episodeSeasonLabel.text = self?.viewModel.season
            self?.episodeSummaryLabel.text = self?.viewModel.episode?.episodeSummary?.removingHTMLOccurrences
            
            if let posterOriginalURL = self?.viewModel.episode?.episodeImage?.original, let posterURL = URL(string: posterOriginalURL) {
                self?.posterImageView.sd_setImage(with: posterURL)
            }
        }
        
        viewModel.fetch(episodeId: episodeId)
    }
}
