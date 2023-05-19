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
    @IBOutlet private weak var favouriteBarButtonItem: UIBarButtonItem!
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
    
    func refreshMovie(model: MovieDetailsViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.overview
        setBarButtonItemAs(favourite: model.isFavourite)
        
        let releaseLabel = UILabel(frame: .zero)
        releaseLabel.text = model.releaseText
        moreInfoStackView.addArrangedSubview(releaseLabel)
        
        let userRateLabel = UILabel(frame: .zero)
        userRateLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        userRateLabel.text = model.userRateText
        moreInfoStackView.addArrangedSubview(userRateLabel)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let isFavourite = favouriteBarButtonItem.image == UIImage(systemName: "star.fill")
        
        setBarButtonItemAs(favourite: !isFavourite)
        
        presenter.markAsFavourite(!isFavourite)
    }
    
    private func setBarButtonItemAs(favourite: Bool) {
        let starImage = UIImage(systemName: favourite ? "star.fill" : "star")
        favouriteBarButtonItem.image = starImage
    }
}
