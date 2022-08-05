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
    
    private lazy var searchSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Series", "People"])
        segmentedControl.selectedSegmentTintColor = .systemRed
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(toggleSearchCategory(_:)), for: .valueChanged)
        return segmentedControl
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
        self.view.addSubview(searchSegmentedControl)
        
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
        searchSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showsSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            showsSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            showsSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchSegmentedControl.topAnchor.constraint(equalTo: showsSearchBar.bottomAnchor),
            searchSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            searchSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            showsCollectionView.topAnchor.constraint(equalTo: searchSegmentedControl.bottomAnchor, constant: 4.0),
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
    
    // MARK: Actions
    
    @objc private func toggleSearchCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel.searchCategory = .series
            
        }
        
        if sender.selectedSegmentIndex == 1 {
            viewModel.searchCategory = .people
        }
        
        self.showsCollectionView.reloadData()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.searchCategory == .series {
            return self.viewModel.seriesResults.count
        }
        
        return self.viewModel.peopleResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SHOWCELL", for: indexPath) as! ShowCollectionViewCell
        showCollectionViewCell.backgroundColor = .clear
        
        if viewModel.searchCategory == .series {
            showCollectionViewCell.configure(show: self.viewModel.seriesResults[indexPath.row].show)
        }
        
        if viewModel.searchCategory == .people {
            showCollectionViewCell.configure(person: self.viewModel.peopleResults[indexPath.row].person)
        }
        
        return showCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.searchCategory == .series {
            coordinator?.showSeries(seriesId: viewModel.seriesResults[indexPath.row].show.showId)
        }
        
        if viewModel.searchCategory == .people {
            coordinator?.showPerson(personId: viewModel.peopleResults[indexPath.row].person.personId)
        }
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
