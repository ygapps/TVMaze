//
//  ShowViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import UIKit
import RealmSwift

class SeriesViewController: UIViewController {

    public weak var coordinator: Coordinator? // Retain Cycle Avoidance
    
    private var seriesId: UInt
    private var viewModel: SeriesViewModel
    
    private lazy var likeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart",
                                                           withConfiguration: UIImage.SymbolConfiguration(scale: .large)),
                                            style: .plain,
                                            target: self,
                                            action: #selector(like(_:)))
        return barButtonItem
    }()

    private lazy var showEpisodesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(EpisodesTableViewCell.self, forCellReuseIdentifier: "EPISODESCELL")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let showNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let showGenresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let showScheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let showSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 20
        return label
    }()
    
    private var isFavorite: Bool {
        let realmDB = try! Realm()
        let likedShow = realmDB.object(ofType: LikedShow.self, forPrimaryKey: seriesId)
        return likedShow != nil
    }
    
    init(seriesId: UInt, viewModel: SeriesViewModel) {
        self.viewModel = viewModel
        self.seriesId = seriesId
        
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
        self.navigationItem.setRightBarButton(likeBarButtonItem, animated: true)
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(posterImageView)
        self.view.addSubview(showNameLabel)
        self.view.addSubview(showScheduleLabel)
        self.view.addSubview(showGenresLabel)
        self.view.addSubview(showSummaryLabel)
        self.view.addSubview(showEpisodesTableView)
        
        if isFavorite {
            likeBarButtonItem.image =  UIImage(systemName: "heart.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        } else {
            likeBarButtonItem.image =  UIImage(systemName: "heart",
                                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        }
    }
    
    private func configureLayout() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        showNameLabel.translatesAutoresizingMaskIntoConstraints = false
        showScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        showGenresLabel.translatesAutoresizingMaskIntoConstraints = false
        showSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        showEpisodesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            posterImageView.widthAnchor.constraint(equalToConstant: 170),
            posterImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            showNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            showNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            showNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            showScheduleLabel.topAnchor.constraint(equalTo: showNameLabel.bottomAnchor, constant: 3.0),
            showScheduleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            showScheduleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            showGenresLabel.topAnchor.constraint(equalTo: showScheduleLabel.bottomAnchor,  constant: 3.0),
            showGenresLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            showGenresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            showSummaryLabel.topAnchor.constraint(equalTo: showGenresLabel.bottomAnchor,  constant: 3.0),
            showSummaryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16.0),
            showSummaryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            showSummaryLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            showEpisodesTableView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5.0),
            showEpisodesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            showEpisodesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            showEpisodesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureViewModel() {
        viewModel.didLoadSeriesDetails = { [weak self] in
            self?.showNameLabel.text = self?.viewModel.seriesDetails?.showName
            self?.showScheduleLabel.text = self?.viewModel.schedule
            self?.showGenresLabel.text = self?.viewModel.genres
            
            if let posterOriginalURL = self?.viewModel.seriesDetails?.showImage?.original, let posterURL = URL(string: posterOriginalURL) {
                self?.posterImageView.sd_setImage(with: posterURL)
            }
            
            if let summary = self?.viewModel.seriesDetails?.showSummary {
                self?.showSummaryLabel.text = summary.removingHTMLOccurrences
            }
        }
        
        viewModel.didLoadEpisodes = { [weak self] in
            self?.showEpisodesTableView.reloadData()
        }
        
        viewModel.fetch(seriesId: seriesId)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
            self.showEpisodesTableView.isHidden = true
        } else {
            self.showEpisodesTableView.isHidden = false
        }
    }
    
    // MARK: Actions
    
    @objc private func like(_ sender: UIBarButtonItem) {
        let realmDB = try! Realm()

        if isFavorite {
            guard let likedShow = realmDB.object(ofType: LikedShow.self, forPrimaryKey: seriesId) else {
                return
            }
            
            try! realmDB.write {
                realmDB.delete(likedShow)
            }
            
            sender.image =  UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large))

        } else {
            
            let likedShow = LikedShow(likedShowId: Int(seriesId),
                                      likedShowName: viewModel.seriesDetails?.showName,
                                      likedShowImageURL: viewModel.seriesDetails?.showImage?.medium)
            
            try! realmDB.write {
                realmDB.add(likedShow)
            }
            
            sender.image =  UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        }
    }
}

extension SeriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.seasons.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.seasons[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let seasonEpisodes = self.viewModel.episodes.filter { $0.episodeSeason == indexPath.section + 1 } // As seasons start from 1 not 0 :)
        
        let episodesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EPISODESCELL", for: indexPath) as! EpisodesTableViewCell
        episodesTableViewCell.backgroundColor = .clear
        episodesTableViewCell.coordinator = coordinator
        episodesTableViewCell.configure(episodes: seasonEpisodes)
        return episodesTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
}
