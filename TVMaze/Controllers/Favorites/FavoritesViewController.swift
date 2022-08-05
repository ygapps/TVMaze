//
//  FavoritesViewController.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    weak var coordinator: FavoritesCoordinator? // Retain Cycle Avoidance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Favorites"
    }
}
