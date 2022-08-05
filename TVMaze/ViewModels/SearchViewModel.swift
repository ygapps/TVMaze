//
//  SearchViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import Foundation

public enum SearchCategory {
    case series
    case people
}

class SearchViewModel {
    
    public var isLoading = false
   
    public var didLoadSearchResults: (() -> ())?
    public var seriesResults: [SearchShow] = []
    public var peopleResults: [SearchPerson] = []

    public var searchCategory: SearchCategory = .series

    public var title: String {
        return "Search"
    }
    
    public func fetch(searchQuery: String) {
        if searchCategory == .series {
            series(searchQuery: searchQuery)
        }
        
        if searchCategory == .people {
            people(searchQuery: searchQuery)
        }
    }
    
    private func series(searchQuery: String) {
        self.isLoading = true
        
        NetworkManager.request(.search(searchQuery: searchQuery)) { [weak self] (result: Result<[SearchShow], Error>) in
            if case .success(let searchResults) = result {
                DispatchQueue.main.async {
                    self?.seriesResults = searchResults
                    self?.didLoadSearchResults?()
                    self?.isLoading = false
                }
            }
        }
    }
    
    private func people(searchQuery: String) {
        self.isLoading = true
        
        NetworkManager.request(.person(searchQuery: searchQuery)) { [weak self] (result: Result<[SearchPerson], Error>) in
            if case .success(let searchResults) = result {
                DispatchQueue.main.async {
                    self?.peopleResults = searchResults
                    self?.didLoadSearchResults?()
                    self?.isLoading = false
                }
            }
        }
    }
}

