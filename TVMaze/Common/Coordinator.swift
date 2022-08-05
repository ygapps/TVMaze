//
//  Coordinator.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
