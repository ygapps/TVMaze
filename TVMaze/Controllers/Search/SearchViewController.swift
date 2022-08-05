//
//  SearchViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private weak var coordinator: SearchCoordinator? // Retain Cycle Avoidance
    private var viewModel: SearchViewModel
    private let disponseBag = DisposeBag()
    
    private lazy var showsSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Series, TV shows and Movies"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var showsCollectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        layout.itemSize = CGSize(width: view.frame.width / 3.4, height: ((view.frame.width / 3.4) * 1.4) + 50)
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: "SHOWCELL")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.addGestureRecognizer(tapGesture)
        return collectionView
    }()
    
    init(coordinator: SearchCoordinator, viewModel: SearchViewModel) {
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
        self.view.addSubview(showsSearchBar)
        
        self.title = viewModel.title
        
        self.showsSearchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] searchQuery in
                self?.viewModel.fetch(searchQuery: searchQuery)
            }
            .disposed(by: disponseBag)
    }
    
    private func configureLayout() {
        showsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        showsSearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showsSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            showsSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            showsSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            showsCollectionView.topAnchor.constraint(equalTo: showsSearchBar.bottomAnchor),
            showsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            showsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            showsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureViewModel() {
        viewModel.didLoadSearchResults = {
            self.showsCollectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SHOWCELL", for: indexPath) as! ShowCollectionViewCell
        showCollectionViewCell.backgroundColor = .clear
        showCollectionViewCell.configure(show: self.viewModel.searchResults[indexPath.row].show)
        return showCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showSeries(seriesId: viewModel.searchResults[indexPath.row].show.showId)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
