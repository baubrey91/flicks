//
//  ViewController.swift
//  flicks
//
//  Created by Brandon on 3/28/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import AFNetworking
import KRProgressHUD

class MoviesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView:           UITableView!
    @IBOutlet weak var collectionView:      UICollectionView!
    @IBOutlet weak var networkErrorView:    UIView!
    
    var endpoint = "now_playing"
    
    let apiKey = "5bf0547b7de4003cc2d3f7365471ee39"
    let baseUrl = "http://image.tmdb.org/t/p/w342"

    var moviesArray = [Movie]()
    var filteredMoviesArray = [Movie]()
    
    lazy var searchBar = UISearchBar(frame: CGRect(0, 0, 200, 20))


    var imageUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search"
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        searchBar.keyboardType = UIKeyboardType.alphabet
        
        let refreshControlTable = UIRefreshControl()
        let refreshControlCollection = UIRefreshControl()

        refreshControlTable.addTarget(self, action: #selector(callService(refreshControl:)), for: UIControlEvents.valueChanged)
        refreshControlCollection.addTarget(self, action: #selector(callService(refreshControl:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControlTable, at: 0)
        collectionView.insertSubview(refreshControlCollection, at: 0)
        
        callService()
        filteredMoviesArray = moviesArray

        tableView.reloadData()
    }
    
    func callService(refreshControl: UIRefreshControl) {
        
        moviesArray = []
        networkErrorView.isHidden = true

        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )
        KRProgressHUD.show()


        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if error != nil {
                print(error)
                self.networkErrorView.isHidden = false
                refreshControl.endRefreshing()

            }
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let payLoad = responseDictionary["results"] as? [NSDictionary]
                {
                    //NSLog("response: \(responseDictionary)")
                    for m in payLoad {
                        let mm = Movie(dict: m)
                        self.moviesArray.append(mm)
                    }
                    self.filteredMoviesArray = self.moviesArray
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                    KRProgressHUD.dismiss()

                }
            }
        });
        task.resume()
        
    }
    
    func callService() {
    
        networkErrorView.isHidden = true
        
        let apiKey = "5bf0547b7de4003cc2d3f7365471ee39"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )

        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if error != nil {
                print(error)
                self.networkErrorView.isHidden = false
            }
            KRProgressHUD.show()
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                    let payLoad = responseDictionary["results"] as? [NSDictionary]{
                    for m in payLoad {
                        let mm = Movie(dict: m)
                        self.moviesArray.append(mm)
                    }
                    KRProgressHUD.dismiss()
                    self.collectionView.reloadData()
                    self.filteredMoviesArray = self.moviesArray
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
    }
    
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        collectionView.isHidden = ((sender.selectedSegmentIndex == 0) ? true : false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewSegue" {
            let vc = segue.destination as! MovieDetailViewController
            let indexPath = tableView.indexPath(for: sender as! MovieCell)!
            vc.movie = filteredMoviesArray[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! MovieCell
            cell.tare.isHidden = false
            filteredMoviesArray[indexPath.row].isTorn = true
            
        }
        if segue.identifier == "collectionViewSegue" {
            let vc = segue.destination as! MovieDetailViewController
            let indexPath = collectionView.indexPath(for: sender as! MovieCollectionViewCell)!
            vc.movie = filteredMoviesArray[indexPath.row]
        }
    }
}

extension MoviesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMoviesArray = []
        for movie in moviesArray {
            if movie.title.contains(searchText){
                filteredMoviesArray.append(movie)
            }
        }
        
        if searchText == "" {
            filteredMoviesArray = moviesArray
            perform(#selector(hideKeyboardWithSearchBar(bar:)), with:searchBar, afterDelay:0)
        }
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func hideKeyboardWithSearchBar(bar:UISearchBar) {
        bar.resignFirstResponder()
    }
}

extension MoviesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = filteredMoviesArray[indexPath.row]
        cell.movieTitle.text = movie.title as? String//posts?[indexPath.row]["blog_name"] as! String
        cell.movieTitle.sizeToFit()
        cell.movieDescription.text = movie.description as? String
        cell.movieDescription.sizeToFit()
        cell.tare.isHidden = !movie.isTorn
        
        if let posterPath = movie.posterPath {
            
            imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImage.fadeInImageRequest(imgURL: imageUrl)
            //fadeInImageRequest(poster: cell.posterImage)
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            filteredMoviesArray[indexPath.row].isTorn = false
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Clear"
    }
}

extension MoviesTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMoviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = filteredMoviesArray[indexPath.row]
        cell.movieTitle.text = movie.title as? String
        cell.movieTitle.sizeToFit()
        
        if let posterPath = movie.posterPath {
            imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImage.fadeInImageRequest(imgURL: imageUrl)
        }
        return cell
    }

}

