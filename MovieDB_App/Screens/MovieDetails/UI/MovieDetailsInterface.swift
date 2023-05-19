//
//  MovieDetailsInterface.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18-5-2023.
//

import UIKit

protocol MovieDetailsInterfaceIn: AnyObject
{
    func refreshMoviePoster(image: UIImage)
    func refreshMovie(model: MovieDetailsViewModel)
}

protocol MovieDetailsInterfaceOut: AnyObject
{
    func didLoad()
    func goBackAction()
    func markAsFavourite(_ favourite: Bool)
}
