//
//  BaseMainViewController.swift
//  Movie
//
//  Created by Andrii on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class BaseMainViewController: UIViewController {

    internal var page: Page?
    internal var movies = [Movie]()
    internal var currentPage = 1
    
    private var isLoading = false
    private var footerView: FooterView?

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        if isPad {
            flowLayout.itemSize = CGSize(width: view.frame.width / 3, height: 300)
        } else {
            flowLayout.itemSize = CGSize(width: view.frame.width, height: 200)
        }
        return flowLayout
    }()
    
    internal lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier)

        return collectionView
    }()
    
    internal var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    //MARK: - Initialization
    @objc init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func loadData() {}
    
    internal func stopLoading() {
        activityIndicator.stopAnimating()
        isLoading = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupLayout()
        setupUI()
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if UIApplication.shared.statusBarOrientation.isLandscape {
            flowLayout.itemSize = CGSize(width: (view.frame.width / 2) - 6, height: 200)
        } else {
            flowLayout.itemSize = CGSize(width: view.frame.width, height: 200)
        }
        
        flowLayout.invalidateLayout()
    }
    
    internal func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    internal func setupUI() {

    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BaseMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.setup(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        guard let url = APIService.shared.posterUrl(posterPath: movie.posterPath ?? "") else { return }
        let cell = cell as! MovieCollectionViewCell
        
        cell.posterImageView.af_setImage(withURL: url,
                                         placeholderImage: nil,
                                         filter: nil,
                                         imageTransition: .crossDissolve(0.2)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        let vc = DetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! MovieCollectionViewCell
        cell.posterImageView.af_cancelImageRequest()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterView.reuseIdentifier, for: indexPath) as! FooterView
        self.footerView = footerView
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = 100.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        var triggerThreshold = Float((diffHeight - frameHeight)) / Float(threshold)
        triggerThreshold = min(triggerThreshold, 0.0)
        let pullRatio = min(abs(triggerThreshold), 1.0)
        if pullRatio >= 1 {
            footerView?.stopAnimate()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight = abs(diffHeight - frameHeight)

        if pullHeight == 0.0 && movies.count < page?.totalResults ?? 0 {
            isLoading = true
            footerView?.startAnimate()
            currentPage = currentPage + 1
            loadData()
        }
        
        if movies.count == page?.totalResults ?? 0 {
            isLoading = true
            collectionView.reloadData()
        }
    }
}
