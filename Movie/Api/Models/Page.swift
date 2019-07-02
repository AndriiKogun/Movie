//
//  Page.swift
//  Movie
//
//  Created by Andrii on 7/2/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

struct Page: Decodable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    let movies: [Movie]
    
    enum CodingKeys : String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
