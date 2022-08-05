//
//  EpisodeViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import Foundation

class EpisodeViewModel {
    
    public var didLoadEpisode: (() -> ())?
    public var episode: Episode?
    
    public var season: String {
        if let episode = episode {
            return "Season \(episode.episodeSeason) . Episode \(episode.episodeNumber)"
        }
        
        return "Unknown Season"
    }
    
    public func fetch(episodeId: UInt) {
        NetworkManager.request(.episodeDetails(episodeId: episodeId)) { [weak self] (result: Result<Episode, Error>) in
            if case .success(let episode) = result {
                DispatchQueue.main.async {
                    self?.episode = episode
                    self?.didLoadEpisode?()
                }
            }
        }
    }
}
