//
//  FavoritesCoordinator.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let favoritesViewController = FavoritesViewController(coordinator: self, viewModel: FavoritesViewModel())
        navigationController.setViewControllers([favoritesViewController], animated: true)
    }
    
    func showSeries(seriesId: UInt) {
        let seriesViewController = SeriesViewController(seriesId: seriesId, viewModel: SeriesViewModel())
        seriesViewController.coordinator = self
        self.navigationController.pushViewController(seriesViewController, animated: true)
    }
}
