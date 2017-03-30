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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    let apiKey = "5bf0547b7de4003cc2d3f7365471ee39"
    var moviesArray = [Movie]()
    var filteredMoviesArray = [Movie]()
    var delegate: tcDelegate? = nil
    var connectionString: String = ""
    var url: URL?

    var imageUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(callService(refreshControl:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        callService()
        filteredMoviesArray = moviesArray

        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
         url = URL(string: (connectionString) + (apiKey))
    }
    
    func callService(refreshControl: UIRefreshControl) {
        
        networkErrorView.isHidden = true

        //let apiKey = "5bf0547b7de4003cc2d3f7365471ee39"
        //let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        KRProgressHUD.show()


        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if error != nil {
                print(error)
                self.networkErrorView.isHidden = false
                refreshControl.endRefreshing()

            }
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,                     let payLoad = responseDictionary["results"] as? [NSDictionary]
                {
                    //NSLog("response: \(responseDictionary)")
                    for m in payLoad {
                        let mm = Movie(dict: m)
                        self.moviesArray.append(mm)
                    }
                    //MBProgressHUD.hide(for: self.view, animated: true)
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
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )
        //MBProgressHUD.showAdded(to: self.view, animated: true)

        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if error != nil {
                print(error)
                self.networkErrorView.isHidden = false
            }
            KRProgressHUD.show()
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                    let payLoad = responseDictionary["results"] as? [NSDictionary]{
                    //print(payLoad)
                    for m in payLoad {
                        let mm = Movie(dict: m)
                        self.moviesArray.append(mm)
                    }
                   // MBProgressHUD.hide(for: self.view, animated: true)
                    KRProgressHUD.dismiss()
                    self.filteredMoviesArray = self.moviesArray
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
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
        let baseUrl = "http://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie.posterPath {
            
            imageUrl = NSURL(string: baseUrl + posterPath)
            fadeInImageRequest(poster: cell.posterImage)
            }
        
        
        return cell
    }
    
    func fadeInImageRequest(poster: UIImageView) {
        
        
        let imageRequest = URLRequest(url: imageUrl as URL)
        
        poster.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: {( imageRequest, imageResponse, image) -> Void in
            
            if imageResponse != nil {
                poster.alpha = 0.0
                
                poster.image = image
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    poster.alpha = 3.0
                })
            } else {
                poster.image = image
            }
        }, failure: {(imageRequest, imageResponse, error) -> Void in
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "movieDetailViewController") as! MovieDetailViewController
        vc.movie = moviesArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

