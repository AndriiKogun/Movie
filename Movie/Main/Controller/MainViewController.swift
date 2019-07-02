//
//  MainViewController.swift
//  TheMovie
//
//  Created by A K on 6/22/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class MainViewController: BaseMainViewController {
    
    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(named: "search_icon"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        return searchBarButtonItem
    }()
    
    private lazy var filterBarButtonItem: UIBarButtonItem = {
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: "filter_icon"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterAction(_:)), for: .touchUpInside)

        let filterBarButtonItem = UIBarButtonItem(customView: filterButton)
        return filterBarButtonItem
    }()
    
    override func loadData() {
        APIService.shared.getPopularMovies(page: currentPage) { [weak self] (page, error) in
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
    
    override func setupLayout() {
        super.setupLayout()
        
        searchBarButtonItem.customView?.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        filterBarButtonItem.customView?.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }

    override func setupUI() {
        title = "Popular"
        navigationItem.setRightBarButtonItems([filterBarButtonItem, searchBarButtonItem], animated: true)
    }
    
    //MARK: - Actions
    @objc private func searchAction(_ sender: UIButton) {
        let vc = SearchViewController()
        vc.delegate = self
        let nc = NavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    @objc private func filterAction(_ sender: UIButton) {
        let vc = FilterViewController()
        vc.delegate = self
        let nc = NavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
}

//MARK: - SearchViewControllerDelegate
extension MainViewController: SearchViewControllerDelegate {
    func search(query: String) {
        let vc = SearchResultsViewController()
        vc.setup(query: query)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func show(movie: Movie) {
        let vc = DetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - FilterViewControllerDelegate
extension MainViewController: FilterViewControllerDelegate {
    func filter(genres: [Genre]) {
        let vc = FilterResultsViewController()
        vc.setup(genres: genres)
        navigationController?.pushViewController(vc, animated: false)
    }
}
