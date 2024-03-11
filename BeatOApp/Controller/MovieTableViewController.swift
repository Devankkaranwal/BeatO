//
//  MovieTableViewController.swift
//  BeatOApp
//
//  Created by Devank on 05/03/24.

import UIKit

class MovieTableViewController: UITableViewController {
    
    var viewModel = MovieViewModel()
    let movieService = MovieService()
    private var movieData: [Movie] = []
    private var currentPage = 1
    private var isLoading = false
    var loadedMovieCount = 0
    private var loadingTimer: Timer?
    private let cellIdentifier: String = "tableCell"
    private var loadingIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovies(page: currentPage)
    }
}

extension MovieTableViewController {
    
    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Popular Movies"
        tableView.reloadData()
    }
    

    
    func fetchMovies(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        movieService.fetchNowPlayingMovies(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    if self.movieData.count < 10 {
                        let remainingCount = min(movies.count, 10 - self.movieData.count)
                        self.movieData += Array(movies.prefix(remainingCount))
                    } else {
                        self.movieData += movies
                    }
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.currentPage += 1
                    self.loadedMovieCount += movies.count
                    if self.loadedMovieCount % 10 == 0 {
                        self.showLoadingIndicator()
                    } else {
                        self.hideLoadingIndicator()
                    }
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
                self.isLoading = false
                self.hideLoadingIndicator()
            }
        }
    }


    
    func showLoadingIndicator() {
        isLoading = true
        tableView.reloadRows(at: [IndexPath(row: movieData.count - 1, section: 0)], with: .automatic)

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.isLoading = false
            self.tableView.reloadRows(at: [IndexPath(row: self.movieData.count - 1, section: 0)], with: .automatic)
        }
    }
    
   
}

// MARK: - UITableView DataSource

extension MovieTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieData.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TableCell

        if indexPath.row < movieData.count {
            cell?.nameLabel.text = self.movieData[indexPath.row].originalTitle
            
            if let releaseDate = self.movieData[indexPath.row].release_date {
                cell?.prepTimeLabel.text = releaseDate
            } else {
                cell?.prepTimeLabel.text = "Unknown"
            }
            
            if let posterPath = self.movieData[indexPath.row].posterPath {
                let posterImageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                
                let task = URLSession.shared.dataTask(with: posterImageUrl!) { (data, response, error) in
                    if let imageData = data {
                        DispatchQueue.main.async {
                            cell?.thumbnailImageView.image = UIImage(data: imageData)
                        }
                    }
                }
                task.resume()
            }
        }
        
        
        if indexPath.row == movieData.count - 1 && isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.color = .black
            activityIndicator.startAnimating()
            activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            activityIndicator.center = (cell?.contentView.center)!
            cell?.contentView.addSubview(activityIndicator)
        } else {
            cell?.accessoryView = nil
        }
        

        return cell!
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard !movieData.isEmpty else {
             print("Error: movieData is empty")
             return
         }
         if indexPath.item < movieData.count {
             let selectedMovie = movieData[indexPath.item]
             print("Selected Movie: \(selectedMovie)")
             
             let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
             destinationVC?.selectedMovieID = selectedMovie.id
             destinationVC?.selectedMovie = selectedMovie
            
             if let destinationVC = destinationVC {
                 self.navigationController?.pushViewController(destinationVC, animated: true)
             }
   
         } else {
             print("Error: Index out of bounds")
         }
    }
    
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = movieData.count - 1
        if indexPath.row == lastElement {
            if !isLoading {
                fetchMovies(page: currentPage)
            }
        } else if indexPath.row == movieData.count && isLoading {
            showLoadingIndicator()
        } else {
            cell.accessoryView = nil
        }
    }

}


extension MovieTableViewController {
    func hideLoadingIndicator() {
        let indexPath = IndexPath(row: movieData.count, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? TableCell {
            cell.accessoryView = nil
        }
    }
}
