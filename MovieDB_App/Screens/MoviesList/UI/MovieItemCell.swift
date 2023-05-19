//
//  MovieItemCell.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import UIKit

class MovieItemCell: UITableViewCell {

    static let cellID = "MovieItemCellID"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    
    private var imageDownloader: ImageDownloader?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.image = nil
    }
    
    func configure(model: MoviesItemCellModel) {
        titleLabel.text = model.title
        releaseLabel.text = model.releaseDate
        
        imageDownloader = ImageDownloader(url: model.imageURL)
        imageDownloader?.download(completed: { [weak self] image in
            self?.imgView.image = image
        })
    }
}
