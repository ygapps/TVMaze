//
//  AppCoordinator.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit



class AppCoordinator {
    
    let window: UIWindow

    var rootViewController: UITabBarController
    var tabCoordinator: TabCoordinator?
        
    init(window: UIWindow, rootViewController: UITabBarController) {
        self.window = window
        self.rootViewController = rootViewController
    }
    
    func start() {
        window.rootViewController = rootViewController
        
        let tabCoordinator = TabCoordinator(tabController: rootViewController)
        tabCoordinator.start()
        
        self.tabCoordinator = tabCoordinator
    }
}
