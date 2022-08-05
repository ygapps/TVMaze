//
//  HomeViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import Foundation

class HomeViewModel {
    
    public var isLoading = false
    private(set) var shows: [Show] = []
    
    public var title: String {
        return "Home"
    }
    
    public var didLoadShows: (() -> ())?
    
    public func fetch(number: UInt) {
        self.isLoading = true
        
        NetworkManager.request(.shows(page: number)) { [weak self] (result: Result<[Show], Error>) in
            if case .success(let shows) = result {
                DispatchQueue.main.async {
                    self?.shows.append(contentsOf: shows)
                    self?.didLoadShows?()
                    self?.isLoading = false
                }
            }
        }
    }
}
