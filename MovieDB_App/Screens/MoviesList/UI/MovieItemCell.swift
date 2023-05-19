//
//  MovieItemCell.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import UIKit

protocol MovieItemCellDelegate: NSObjectProtocol {
    func movieItemCellDidMarkAs(favourite: Bool, movieId: Int)
}

class MovieItemCell: UITableViewCell {

    static let cellID = "MovieItemCellID"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    weak var delegate: MovieItemCellDelegate?
    
    private var imageDownloader: ImageDownloader?
    private var movieId: Int?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.image = nil
    }
    
    func configure(model: MoviesItemCellModel) {
        movieId = model.id
        titleLabel.text = model.title
        releaseLabel.text = model.releaseDate
        let starImage = UIImage(systemName: model.isFavourite ? "star.fill" : "star")
        favouriteButton.setImage(starImage, for: .normal)
        
        imageDownloader = ImageDownloader(url: model.imageURL)
        imageDownloader?.download(completed: { [weak self] image in
            self?.imgView.image = image
        })
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let isFavourite = sender.image(for: .normal) == UIImage(systemName: "star.fill")
        let newState = !isFavourite
        let starImage = UIImage(systemName: newState ? "star.fill" : "star")
        sender.setImage(starImage, for: .normal)
        
        if let movieId {
            delegate?.movieItemCellDidMarkAs(favourite: newState, movieId: movieId)
        }
    }
}
