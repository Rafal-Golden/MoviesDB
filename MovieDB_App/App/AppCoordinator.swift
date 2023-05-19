//
//  AppCoordinator.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    public let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let moviesListVC = MoviesListCoordinator(navigationController: navigationController).build()
        self.navigationController.viewControllers = [moviesListVC]
    }
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
        
    }
}
