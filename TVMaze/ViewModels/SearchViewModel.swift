//
//  SearchViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import Foundation

class SearchViewModel {
    
    public var isLoading = false
   
    public var didLoadSearchResults: (() -> ())?
    public var searchResults: [SearchShow] = []

    public var title: String {
        return "Search"
    }
    
    public func fetch(searchQuery: String) {
        self.isLoading = true
        
        NetworkManager.request(.search(searchQuery: searchQuery)) { [weak self] (result: Result<[SearchShow], Error>) in
            if case .success(let searchResults) = result {
                DispatchQueue.main.async {
                    self?.searchResults = searchResults
                    self?.didLoadSearchResults?()
                    self?.isLoading = false
                }
            }
        }
    }
}

