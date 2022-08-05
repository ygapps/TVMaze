//
//  TabCoordinator.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

class TabCoordinator {
    
    var tabController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    var homeCoordinator: HomeCoordinator
    var searchCoordinator: SearchCoordinator
    var favoritesCoordinator: FavoritesCoordinator
    
    init(tabController: UITabBarController) {
        self.tabController = tabController
        
        self.homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        self.searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        self.favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController())
    }
    
    func start() {
            
        homeCoordinator.start()
        searchCoordinator.start()
        favoritesCoordinator.start()

        let homeController = homeCoordinator.navigationController
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "tv"), selectedImage: nil)
        childCoordinators.append(homeCoordinator)
        
        let searchController = searchCoordinator.navigationController
        searchController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        childCoordinators.append(searchCoordinator)
    
        let favoritesController = favoritesCoordinator.navigationController
        favoritesController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: nil)
        childCoordinators.append(favoritesCoordinator)
    
        tabController.setViewControllers([homeController, searchController, favoritesController], animated: true)
        tabController.tabBar.isTranslucent = true
    }
}
