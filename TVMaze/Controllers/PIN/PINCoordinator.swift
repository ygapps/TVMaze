//
//  PINCoordinator.swift
//  TVMaze
//
//  Created by Youssef on 8/6/22.
//

import UIKit

class PINCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let pinController = PINViewController(coordinator: self)
        navigationController.setViewControllers([pinController], animated: true)
    }
    
    func showPIN() {
        var options = ALOptions()
        options.image = UIImage(systemName: "person")!
        options.title = "TVMaze"
        options.subtitle = "Enter PIN"

        AppLocker.present(with: .create, and: options, over: self.navigationController)
    }
    
    func removePIN() {
        var options = ALOptions()
        options.image = UIImage(systemName: "person")!
        options.title = "TVMaze"
        options.subtitle = "Enter PIN"

        AppLocker.present(with: .deactive, and: options, over: self.navigationController)
    }
}
