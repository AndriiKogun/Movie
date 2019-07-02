//
//  MovieDetails.swift
//  Movie
//
//  Created by A K on 6/30/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

struct MovieDetails: Decodable {
    var backgroundImagePath: String?
    var budget: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var productionCuntries: [ProductionCuntries]
    var voteAverage: Float?
    var runtime: Int?
    var status: String?
    var genre: [Genre]
    
    enum CodingKeys : String, CodingKey {
        case backgroundImagePath = "backdrop_path"
        case budget = "budget"
        case title = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case productionCuntries = "production_countries"
        case runtime = "runtime"
        case status = "status"
        case genre = "genres"
        case voteAverage = "vote_average"
    }
}
