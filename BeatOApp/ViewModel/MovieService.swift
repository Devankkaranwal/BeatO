//
//  MovieService.swift
//  BeatOApp
//
//  Created by Devank on 05/03/24.

import Foundation
import UIKit


class MovieService {
    
    var error: Error?
    
    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=909594533c98883408adef5d56143539&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        DispatchQueue.main.async {
           
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(responseString)")
            }

            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    
    
    func fetchMovieDetail(for movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=909594533c98883408adef5d56143539&language=en-US"
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data httpResponse"])))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response fetchMovieDetail: \(responseString)")
            }
            do {
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(movieDetail))
                }
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    
    
    
    func fetchVideos(for movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=909594533c98883408adef5d56143539&language=en-US"

        print(urlString, "-----urlString--fetchVideos-------")

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data httpResponse"])))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response fetchVideos: \(responseString)")
            }
            do {
               
                let decoder = JSONDecoder()
                let videosResponse = try decoder.decode(VideoResponse.self, from: data)

                
                DispatchQueue.main.async {
                    completion(.success(videosResponse.results))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}




enum CustomError: Error {
    case noMoviesAvailable
}


