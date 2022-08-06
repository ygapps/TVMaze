//
//  FavoritesViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    private weak var coordinator: FavoritesCoordinator? // Retain Cycle Avoidance

    private var viewModel: FavoritesViewModel

    private lazy var likedShowsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LIKEDCELL")
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(coordinator: FavoritesCoordinator, viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
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
        configureViewModel()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.title = viewModel.title
        
        self.view.addSubview(likedShowsTableView)
    }
    
    private func configureLayout() {
        likedShowsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likedShowsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            likedShowsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            likedShowsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            likedShowsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureViewModel() {
        viewModel.didReceiveUpdates = { [weak self] in
            self?.likedShowsTableView.reloadData()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.likedShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let likedShowCell = tableView.dequeueReusableCell(withIdentifier: "LIKEDCELL", for: indexPath)
        
        if let mediumURL = viewModel.likedShows[indexPath.row].likedShowImageURL, let imageURL = URL(string: mediumURL) {
            likedShowCell.imageView?.sd_setImage(with: imageURL)
            likedShowCell.imageView?.layer.masksToBounds = true
            likedShowCell.imageView?.layer.cornerRadius = 5
            likedShowCell.imageView?.layer.cornerCurve = .continuous
        }
        
        likedShowCell.textLabel?.text = viewModel.likedShows[indexPath.row].likedShowName
        return likedShowCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.remove(seriesId: viewModel.likedShows[indexPath.row].likedShowId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showSeries(seriesId: UInt(viewModel.likedShows[indexPath.row].likedShowId))
    }
}
