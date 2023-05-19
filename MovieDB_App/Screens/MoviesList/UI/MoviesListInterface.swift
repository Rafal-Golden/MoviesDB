//
//  MoviesListInterface.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17-5-2023.
//

import UIKit

protocol MoviesListInterfaceIn: AnyObject
{
    func startLoading()
    func refreshList()
    func showFailureInfo(message: String)
    func setTitle(_ title: String)
}

protocol MoviesListInterfaceOut: AnyObject
{
    var moviesModel: MoviesModel { get }
    
    func didLoad()
    func didSelectedCell(index: Int)
}
