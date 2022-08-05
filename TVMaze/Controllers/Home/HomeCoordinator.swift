//
//  HomeCoordinator.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let homeController = HomeViewController(coordinator: self, viewModel: HomeViewModel())
        navigationController.setViewControllers([homeController], animated: true)
    }
    
    func showSeries(seriesId: UInt) {
        let seriesViewController = SeriesViewController(seriesId: seriesId, viewModel: SeriesViewModel())
        seriesViewController.coordinator = self
        self.navigationController.pushViewController(seriesViewController, animated: true)
    }
    
    func showEpisode(episodeId: UInt) {
        let episodeViewController = EpisodeViewController(episodeId: episodeId, viewModel: EpisodeViewModel())
        self.navigationController.pushViewController(episodeViewController, animated: true)
    }
}
