//
//  PersonViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/6/22.
//

import Foundation

class PersonViewModel {
    
    public var didLoadPerson: (() -> ())?
    public var person: Person?
    
    public func fetch(personId: UInt) {
        NetworkManager.request(.personDetails(personId: personId)) { [weak self] (result: Result<Person, Error>) in
            if case .success(let person) = result {
                DispatchQueue.main.async {
                    self?.person = person
                    self?.didLoadPerson?()
                }
            }
        }
    }
}
