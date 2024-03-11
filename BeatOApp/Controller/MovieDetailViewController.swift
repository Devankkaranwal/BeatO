//
//  MovieDetailViewController.swift
//  BeatOApp
//
//  Created by Devank on 06/03/24.

import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var viewPg13: UIView!
    @IBOutlet weak var lblPg13: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTagline: UILabel!
    @IBOutlet weak var lblAdventure: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblScience: UILabel!
    @IBOutlet weak var recommendationTrailerCollectionView: UICollectionView!
 
    var movieDetails: [MovieDetail]?
    var selectedMovie: Movie?
    let movieService = MovieService()
    var viewModel = MovieViewModel()
    var selectedMovieID: Int?
    var error: Error?
    var onError: ((Error) -> Void)?
    var onDataUpdate: (() -> Void)?
    var movieID: Int?
    var movieDetail: MovieDetail?
    var videos: [Video] = []
    

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendationTrailerCollectionView.dataSource = self
        recommendationTrailerCollectionView.delegate = self
        
        self.recommendationTrailerCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "Home")
        
        print(selectedMovieID,"idddddddddd----")
        viewModel.selectedMovieID = selectedMovieID
        fetchMovieDetail()
        fetchVideos()
        fetchCastAndVideos()
        self.loadDetails()
   
    }
    
    
    
    func fetchMovieDetail() {
        guard let movieID = selectedMovieID else {
            return
        }

        movieService.fetchMovieDetail(for: movieID) { [weak self] result in
            switch result {
            case .success(let movieDetail):
                
                DispatchQueue.main.async {
                    self?.updateUI(with: movieDetail)
                    self?.lblDate.text = movieDetail.release_date
         self?.lblTagline.text = movieDetail.tagline
                }
            case .failure(let error):
                print("Failed to fetch movie details:", error)
                
            }
        }
    }
    
 
    
    
        func fetchVideos() {
            guard let movieID = selectedMovieID else {
                return
            }
            
            
            movieService.fetchVideos(for: movieID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let videos):
                    self.videos = videos
                    print(" fetching  self.videos = videos: \( self.videos = videos)")
                case .failure(let error):
                    print("Error fetching videos: \(error)")
                }
            }
            
         
            
        }
    
    func updateUI(with movieDetail: MovieDetail) {
        
        guard !movieDetail.genres.isEmpty else {
            return
        }
        
        lblAdventure.text = movieDetail.genres[0].name
        lblAction.text = movieDetail.genres.count > 1 ? movieDetail.genres[1].name : ""
        lblScience.text = movieDetail.genres.count > 2 ? movieDetail.genres[2].name : ""
    }

    
    
    private func loadDetails() {
        movieTitle.text! = (selectedMovie?.title)!
        movieOverview.text! = (selectedMovie?.overview)!
        

        if let movie = selectedMovie {
            if let posterPath = movie.posterPath,
               let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: posterURL) {
                        DispatchQueue.main.async {
                            self.posterImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func fetchCastAndVideos() {
        print(viewModel.selectedMovieID,"movieID---")
        guard let movieID = viewModel.selectedMovieID else {
            return
        }

        
        movieService.fetchVideos(for: movieID) { [weak self] result in
            switch result {
            case .success(let videos):
                print("Fetched videos:", videos)
                DispatchQueue.main.async {
                    self?.recommendationTrailerCollectionView.reloadData()
                   
                }
            case .failure(let error):
                print("Error fetching videos:", error)
            }
        }
        
        

        
        movieService.fetchMovieDetail(for: movieID) { [weak self] result in
                    switch result {
                    case .success(let movieDetail):
                        print("Movie detail fetched:", movieDetail)
                        self?.movieDetails = [movieDetail]
                        self?.error = nil
                        self?.onDataUpdate?()
                        self?.loadDetails()
                        DispatchQueue.main.async {
                                       self?.lblDate.text = movieDetail.release_date
                            self?.lblTagline.text = movieDetail.tagline
                                   }
                    case .failure(let error):
                        print("Failed to fetch movie details:", error)
                        self?.error = error
                        self?.onError?(error)
                        
                    }
                }

        fetchMovieDetail()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    

    
    @IBAction func btnPlayed(_ sender: Any) {
   
        guard let videoKey = videos[(sender as AnyObject).tag].key else {
               print("Video key not found")
               return
           }
           guard let videoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else {
               return
           }
           videoViewController.videoURL = URL(string: "https://www.youtube.com/embed/\(videoKey)")
           
           present(videoViewController, animated: true, completion: nil)
    }

    
    
    
    @IBAction func addButtonTappedAddtoList(_ sender: UIButton) {
         
          let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          
          let addToFavoritesAction = UIAlertAction(title: "Add to Favorites", style: .default) { _ in
              
              print("Add to Favorites tapped")
          }
          alertController.addAction(addToFavoritesAction)
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          present(alertController, animated: true, completion: nil)
      }
    
    @IBAction func btnSaved(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
       
        let addToListAction = UIAlertAction(title: "Mark as Saved", style: .default) { _ in
           
            print("Mark as Saved")
        }
        alertController.addAction(addToListAction)
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    

    @IBAction func addButtonTappedHeart(_ sender: UIButton) {
          
          let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          
         
          let addToListAction = UIAlertAction(title: "Mark as Favourite", style: .default) { _ in
             
              print("Mark as Favourite")
          }
          alertController.addAction(addToListAction)
          
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          
          present(alertController, animated: true, completion: nil)
      }
    
    
}




extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: - Number of Items in Section


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return videos.count
        }
        
    


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trailer", for: indexPath) as! TrailerCollectionViewCell
    
        let video = videos[indexPath.item]

        guard let videoKey = videos[indexPath.item].key else {return UICollectionViewCell()}

        guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else {return UICollectionViewCell()}
        print(url,"-----youtube vidosss -------------------")
        
        if let webView = cell.trailerWebView {
            webView.load(URLRequest(url: url))
        }
        
        print("name---",videos[indexPath.item].name)
        
        if let name = videos[indexPath.item].name {
            cell.blbName.text = name
        } else {
            cell.blbName.text = "Unknown Name"
        }

        
        return cell
    }


}

extension MovieDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load web content: \(error)")
       
    }
}

