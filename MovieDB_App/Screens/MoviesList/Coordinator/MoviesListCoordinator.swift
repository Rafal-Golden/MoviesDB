//
//  MoviesListCoordinator.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17-5-2023.
//

import UIKit

class MoviesListCoordinator: Coordinator
{
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func build() -> UIViewController {
        let vc = UIStoryboard(name: "MoviesList", bundle: nil).instantiateInitialViewController() as! MoviesListViewController
        let presenter = MoviesListPresenter(ui: vc, coordinator: self)
        vc.presenter = presenter
        return vc
    }
    
    //MARK: - coordinator protocol
    
    func start() {
        let vc = build()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
        switch destination {
            case .movieDetails(let input):
                MovieDetailsCoordinator(navigationController: navigationController, input: input).start()
                
            default: break
        }
    }
}
