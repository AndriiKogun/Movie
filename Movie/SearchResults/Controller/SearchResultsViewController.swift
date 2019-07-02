//
//  SearchResultsViewController.swift
//  Movie
//
//  Created by Andrii on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class SearchResultsViewController: BaseMainViewController {
    
    private var query = ""
    
    func setup(query: String) {
        self.query = query
    }
    
    override func loadData() {
        APIService.shared.getFilteredMovies(query: query, page: currentPage) { [weak self] (page, error) in
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
        title = "Search Results"
    }
}
