//
//  Genre.swift
//  Movie
//
//  Created by A K on 6/30/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

struct GenreResult: Decodable {
    var genres: [Genre]
    
    enum CodingKeys : String, CodingKey {
        case genres = "genres"
    }
}

struct Genre: Decodable {
    var id: Int
    var name: String
}
