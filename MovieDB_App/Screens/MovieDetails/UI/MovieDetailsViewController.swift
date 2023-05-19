//
//  MovieDetailsViewController.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18-5-2023.
//

import UIKit

class MovieDetailsViewController: UIViewController, MovieDetailsInterfaceIn
{
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var moreInfoStackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    public var presenter: MovieDetailsInterfaceOut!

    //MARK: - init & life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.didLoad()
    }
    
    // MARK: MovieDetailsInterfaceIn
    
    func refreshMoviePoster(image: UIImage) {
        imageView.image = image
    }
    
    func refreshMovie(input: MovieDetailsInput) {
        titleLabel.text = input.title
        descriptionLabel.text = input.overview
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.presenter.goBackAction()
        }))
        
        present(alert, animated: true)
    }
}
