//
//  EpisodesCollectionViewCell.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import UIKit

class EpisodesTableViewCell: UITableViewCell {
    
    public weak var coordinator: Coordinator?
    
    private lazy var episodesCollectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.itemSize = CGSize(width: self.frame.width / 3.4, height: ((self.frame.width / 3.4) * 1.4) + 50)

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: "EPISODECELL")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private var episodes: [Episode] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureLayoutConstraints()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func configureViews() {
        contentView.addSubview(episodesCollectionView)
    }
    
    private func configureLayoutConstraints() {
        episodesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            episodesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            episodesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            episodesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(episodes: [Episode]) {
        self.episodes = episodes
        self.episodesCollectionView.reloadData()
    }
}

extension EpisodesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EPISODECELL", for: indexPath) as! ShowCollectionViewCell
        showCollectionViewCell.backgroundColor = .clear
        showCollectionViewCell.posterImageView.contentMode = .scaleAspectFill
        showCollectionViewCell.showNameLabel.numberOfLines = 3
        showCollectionViewCell.configure(episode: self.episodes[indexPath.row])
        return showCollectionViewCell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let coordinator = coordinator as? HomeCoordinator {
            coordinator.showEpisode(episodeId: self.episodes[indexPath.row].episodeId)
        }
        
        if let coordinator = coordinator as? SearchCoordinator {
            coordinator.showEpisode(episodeId: self.episodes[indexPath.row].episodeId)
        }
    }
}
