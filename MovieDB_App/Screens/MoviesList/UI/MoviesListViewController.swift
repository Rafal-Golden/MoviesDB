//
//  MoviesListViewController.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17-5-2023.
//

import UIKit

class MoviesListViewController: UIViewController, MoviesListInterfaceIn
{
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var failureInfoLabel: UILabel!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    public var presenter: MoviesListInterfaceOut!

    private var items: [MoviesItemCellModel] {
        return presenter.moviesModel.items
    }
    
    //MARK: - init & life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.didLoad()
        
        failureInfoLabel.text = ""
        
        if !items.isEmpty {
            loadingView.stopAnimating()
        }
    }
    
    // MARK: MoviesListInterfaceIn
    
    func startLoading() {
        failureInfoLabel.alpha = 0
        loadingView.startAnimating()
    }
    
    func refreshList() {
        loadingView.stopAnimating()
        tableView.reloadData()
    }
    
    func showFailureInfo(message: String) {
        failureInfoLabel.text = message
        
        UIView.animate(withDuration: 0.33) {
            self.failureInfoLabel.alpha = 1.0
        }
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        
    }
}

extension MoviesListViewController: MovieItemCellDelegate {
    
    func movieItemCellDidMarkAs(favourite: Bool, movieId: Int) {
        guard let selectedItem = self.items.filter({ $0.id == movieId }).first else { return }
        
        selectedItem.isFavourite = favourite
        presenter.selectedButton(favourite: favourite, movieId: movieId)
    }
}

extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = MovieItemCell.cellID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MovieItemCell
        
        let item = items[indexPath.row]
        cell.delegate = self
        cell.configure(model: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if items.count > 1 && indexPath.row == items.count - 1 {
            presenter.loadNextPage()
        }
    }
}

extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        self.presenter.didSelectedCell(index: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
