//
//  ShowViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import Foundation

class SeriesViewModel {
    
    public var didLoadSeriesDetails: (() -> ())?
    public var didLoadEpisodes: (() -> ())?
    
    public var seriesDetails: Show?
    public var episodes: [Episode] = []
    
    public var genres: String {
        if let showGenres = seriesDetails?.showGenres {
            return showGenres.joined(separator: " . ")
        }
        
        return "Unknown Genres"
    }
    
    public var schedule: String {
        if let schedule = seriesDetails?.showSchedule {
            return "On " + schedule.days.joined(separator: " . ")  + " at " + schedule.time
        }
        
        return "Unknown Schedule"
    }
    
    public var seasons: [String] {
        var seasons: [UInt] = []
        
        episodes.forEach { episode in
            if !seasons.contains(episode.episodeSeason) {
                seasons.append(episode.episodeSeason)
            }
        }
        
        return seasons.map { "Season \($0)" }
    }
    
    public func fetch(seriesId: UInt) {
        
        NetworkManager.request(.showsDetails(seriesId: seriesId)) { [weak self] (result: Result<Show, Error>) in
            if case .success(let show) = result {
                DispatchQueue.main.async {
                    self?.seriesDetails = show
                    self?.didLoadSeriesDetails?()
                }
            }
        }
        
        NetworkManager.request(.episodes(seriesId: seriesId)) { [weak self] (result: Result<[Episode], Error>) in
            if case .success(let episodes) = result {
                DispatchQueue.main.async {
                    self?.episodes = episodes
                    self?.didLoadEpisodes?()
                }
            }
        }
    }
}
