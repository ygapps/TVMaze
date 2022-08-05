//
//  ShowCollectionViewCell.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit
import SDWebImage

class ShowCollectionViewCell: UICollectionViewCell {
    
    public let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    public let showNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    private let showStartDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func configureViews() {
        addSubview(posterImageView)
        addSubview(showNameLabel)
        addSubview(showStartDateLabel)
        
    }
    
    private func configureLayoutConstraints() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        showNameLabel.translatesAutoresizingMaskIntoConstraints = false
        showStartDateLabel.translatesAutoresizingMaskIntoConstraints = false
   
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.0)
        ])
        
        NSLayoutConstraint.activate([
            showNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5.0),
            showNameLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            showNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5.0)
        ])
        
        NSLayoutConstraint.activate([
            showStartDateLabel.topAnchor.constraint(equalTo: showNameLabel.bottomAnchor, constant: 2.0),
            showStartDateLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            showStartDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5.0),
            showStartDateLabel.heightAnchor.constraint(equalToConstant: 16.0)
        ])
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
        self.showNameLabel.text = nil
        self.showStartDateLabel.text = nil
    }
    
    public func configure(show: Show) {

        if let posterMediumURL = show.showImage?.medium, let posterURL = URL(string: posterMediumURL) {
            self.posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(systemName: "sparkles.tv.fill"))
        }
        
        self.showNameLabel.text = show.showName
        self.showStartDateLabel.text = show.showPremieredYear
    }
    
    public func configure(episode: Episode) {

        if let posterMediumURL = episode.episodeImage?.medium, let posterURL = URL(string: posterMediumURL) {
            self.posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(systemName: "sparkles.tv.fill"))
        }
        
        self.showNameLabel.text = episode.episodeName
    }
}
