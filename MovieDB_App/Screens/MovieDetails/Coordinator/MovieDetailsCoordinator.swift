//
//  MovieDetailsCoordinator.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18-5-2023.
//

import UIKit

class MovieDetailsCoordinator: Coordinator
{
    let navigationController: UINavigationController
    let input: MovieDetailsInput
    
    init(navigationController: UINavigationController, input: MovieDetailsInput) {
        self.navigationController = navigationController
        self.input = input
    }
    
    func build() -> UIViewController {
        let vc = UIStoryboard(name: "MovieDetails", bundle: nil).instantiateInitialViewController() as! MovieDetailsViewController
        let presenter = MovieDetailsPresenter(ui: vc, coordinator: self, input: input)
        vc.presenter = presenter
        return vc
    }
    
    //MARK: - coordinator protocol
    
    func start() {
        let vc = build()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
        switch destination {
            case .back:
                navigationController.popViewController(animated: true)
            
            default: break
        }
    }
}
