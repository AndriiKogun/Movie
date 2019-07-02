//
//  DetailsViewController.swift
//  TheMovie
//
//  Created by A K on 6/24/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var productionCuntriesLabel: UILabel!
    @IBOutlet private weak var budgetLabel: UILabel!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let movie: Movie
    private var movieDetails: MovieDetails!
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.alpha = 0
        activityIndicator.startAnimating()
    }
    
    private func setupUI() {
        activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1
        }
        
        view.backgroundColor = UIColor.white
        setupImageView(posterImageView, imagePath: movieDetails.posterPath)
        setupImageView(backgroundImageView, imagePath: movieDetails.backgroundImagePath)
        
        titleLabel.text = movieDetails.title ?? "none"
        dateLabel.text = movieDetails.releaseDate ?? "none"
        
        if let budget = movieDetails.budget {
            budgetLabel.text = String(budget) + " $"
        } else {
           budgetLabel.text = "--"
        }
        
        if let runtime = movieDetails.runtime {
            runtimeLabel.text = String(runtime) + " min"
        } else {
            runtimeLabel.text = "--"
        }

        if let overview = movieDetails.overview {
            overviewLabel.text = overview
        } else {
            overviewLabel.text = "none"
        }

        if let overview = movieDetails.voteAverage {
            voteAverageLabel.text = String(overview) 
        } else {
            voteAverageLabel.text = "--"
        }
        
        var productionCuntries = ""
        
        for (index, country) in movieDetails.productionCuntries.enumerated() {
            productionCuntries.append(country.iso_3166_1)
            if index < movieDetails.productionCuntries.count - 1 {
                productionCuntries.append(", ")
            }
        }
        
        productionCuntriesLabel.text = productionCuntries
    }
    
    private func loadData() {
        APIService.shared.getMovieDetails(movieId: movie.id) {[weak self] (movieDetails, error) in
            if let self = `self` {
                self.movieDetails = movieDetails
                DispatchQueue.main.async {
                    self.setupUI()
                }
            }
        }
    }
    
    private func setupImageView(_ imageView: UIImageView, imagePath: String?) {
        guard let url = APIService.shared.posterUrl(posterPath: imagePath ?? "") else { return }

        imageView.af_setImage(withURL: url,
                              placeholderImage: nil,
                              filter: nil,
                              imageTransition: .crossDissolve(0.2))
    
    }
}
