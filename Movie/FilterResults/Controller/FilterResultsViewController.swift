//
//  FilterResultsViewController.swift
//  Movie
//
//  Created by A K on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class FilterResultsViewController: BaseMainViewController {

    private var genres = [Genre]()
    
    func setup(genres: [Genre]) {
        self.genres = genres
    }
    
    override func loadData() {
        APIService.shared.getMoviesFilteredByGenre(genres: genres, page: currentPage) { [weak self]  (page, error) in
            if let self = `self` {
                if let page = page {
                    self.page = page
                    self.stopLoading()

                    var indexPaths = [IndexPath]()
                    for (index, _) in page.movies.enumerated() {
                        indexPaths.append(IndexPath(row: self.movies.count + index, section: 0))
                    }
                    
                    self.movies.append(contentsOf: page.movies)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func setupUI() {
        title = "Filter Results"
    }
}
