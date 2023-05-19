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
    func refreshMovie(input: MovieDetailsInput)
    func showErrorAlert(message: String)
}

protocol MovieDetailsInterfaceOut: AnyObject
{
    func didLoad()
    func goBackAction()
}
