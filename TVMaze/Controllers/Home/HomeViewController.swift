//
//  HomeViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

class HomeViewController: UIViewController {
    private weak var coordinator: HomeCoordinator? // Retain Cycle Avoidance
    private var viewModel: HomeViewModel
    
    private(set) var currentSeriesPage: UInt = 0
    
    private lazy var showsCollectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        layout.itemSize = CGSize(width: view.frame.width / 3.4, height: ((view.frame.width / 3.4) * 1.4) + 50)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: "SHOWCELL")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(coordinator: HomeCoordinator, viewModel: HomeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureLayout()
        configureViewModel()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(showsCollectionView)

        self.title = viewModel.title
    }
    
    private func configureLayout() {
        showsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            showsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            showsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            showsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureViewModel() {
        viewModel.didLoadShows = {
            self.showsCollectionView.reloadData()
        }
        
        viewModel.fetch(number: currentSeriesPage)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.shows.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SHOWCELL", for: indexPath) as! ShowCollectionViewCell
        showCollectionViewCell.backgroundColor = .clear
        showCollectionViewCell.configure(show: self.viewModel.shows[indexPath.row])
        return showCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showSeries(seriesId: viewModel.shows[indexPath.row].showId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.showsCollectionView.contentOffset.y >= (self.showsCollectionView.contentSize.height - self.showsCollectionView.bounds.size.height)) {
            
            if !viewModel.isLoading {
                self.currentSeriesPage = currentSeriesPage + 1
                self.viewModel.fetch(number: currentSeriesPage)
            }
        }
    }
}
