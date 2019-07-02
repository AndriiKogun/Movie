//
//  ServerManager.swift
//  TheMovie
//
//  Created by A K on 6/22/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit
import Alamofire

class APIService: UIView {

    static let shared = APIService()
    
    private let key = "3ef198ce95e541d36fc1e28a78514d6d"
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func posterUrl(posterPath: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    func getPopularMovies(page: Int, completionHandler: @escaping (Page?, Error?) -> ()) {
        let parameters: [String : Any] = ["api_key" : key,
                                          "page"    : page]

        Alamofire.request(baseUrl + "/movie/popular", method: .get, parameters: parameters, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = response.data {
                    do {
                        let model = try JSONDecoder().decode(Page.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(model, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, response.error)
                }
            }
        })
    }
    
    func getFilteredMovies(query: String, page: Int, completionHandler: @escaping (Page?, Error?) -> ()) {
        let parameters: [String : Any] = ["api_key" : key,
                                          "query"   : query,
                                          "page"    : page]
        
        Alamofire.request(baseUrl + "/search/movie", method: .get, parameters: parameters, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = response.data {
                    do {
                        let model = try JSONDecoder().decode(Page.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(model, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, response.error)
                }
            }
        })
    }
    
    func getMoviesFilteredByGenre(genres: [Genre], page: Int, completionHandler: @escaping (Page?, Error?) -> ()) {
        var genresList = ""
        genres.forEach { (genre) in
            genresList.append(String(genre.id) + ",")
        }
        
        let parameters: [String : Any] = ["api_key"     : key,
                                          "with_genres" : genresList,
                                          "page"        : page]
        
        Alamofire.request(baseUrl + "/discover/movie", method: .get, parameters: parameters, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = response.data {
                    do {
                        let model = try JSONDecoder().decode(Page.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(model, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, response.error)
                }
            }
        })
    }
    
    func getMovieDetails(movieId: Int, completionHandler: @escaping (MovieDetails?, Error?) -> ()) {
        let parameters: [String : Any] = ["api_key" : key]
        
        Alamofire.request(baseUrl + "/movie/" + String(movieId), method: .get, parameters: parameters, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = response.data {
                    do {
                        let model = try JSONDecoder().decode(MovieDetails.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(model, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, response.error)
                }
            }
        })
    }
    
    func getMovieGenres(completionHandler: @escaping ([Genre]?, Error?) -> ()) {
        let parameters: [String : Any] = ["api_key" : key]
        
        Alamofire.request(baseUrl + "/genre/movie/list", method: .get, parameters: parameters, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = response.data {
                    do {
                        let model = try JSONDecoder().decode(GenreResult.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(model.genres, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, response.error)
                }
            }
        })
    }
}





