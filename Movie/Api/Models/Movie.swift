//
//  Movie.swift
//  Movie
//
//  Created by A K on 6/30/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

struct Movie: Decodable {
    var id: Int
    var voteAverage: Float?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case voteAverage = "vote_average"
        case title = "title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
