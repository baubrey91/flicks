//
//  ViewController.swift
//  flicks
//
//  Created by Brandon on 3/28/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var moviesArray: [NSDictionary]?;
    var filteredMoviesArray: [NSDictionary]?

    var imageUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callService()
        filteredMoviesArray = moviesArray

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callService() {
    
        let apiKey = "5bf0547b7de4003cc2d3f7365471ee39"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{//, let results = responseDictionary["title"] as? NSDictionary{
                    print(responseDictionary["results"]!)
                    self.moviesArray = responseDictionary["results"] as? [NSDictionary]
                    self.filteredMoviesArray = self.moviesArray

                    self.tableView.reloadData()
                    print(self.moviesArray)
                }
            }
            
        });
        task.resume()
    }
    
    func getJSON(_ url: String, completionHandler: @escaping ((_ json: AnyObject) -> Void)) {
        let nsURL = URL(string: url)!
        let session = URLSession.shared
        let task = session.dataTask(with: nsURL, completionHandler: { data, response, error -> Void in
            if error != nil{
                completionHandler(error as AnyObject)
            }
            if data != nil {
                let jsonData = (try! JSONSerialization.jsonObject( with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [String:Any]
                
                completionHandler(jsonData as AnyObject)
            }
            session.invalidateAndCancel()
        })
        task.resume()
    }

}

extension MoviesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.moviesArray?.count else{
            return 3
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        if let movie = filteredMoviesArray?[indexPath.row]{
        cell.movieTitle.text = movie["title"] as? String//posts?[indexPath.row]["blog_name"] as! String
        cell.movieDescription.text = movie["overview"] as? String
        let baseUrl = "http://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            
            imageUrl = NSURL(string: baseUrl + posterPath)
            fadeInImageRequest(poster: cell.posterImage)
            }
        }
        
        return cell
    }
    
    func fadeInImageRequest(poster: UIImageView) {
        
        
        let imageRequest = URLRequest(url: imageUrl as URL)
        
        poster.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: {( imageRequest, imageResponse, image) -> Void in
            
            // image response will be nil if image is cached
            
            if imageResponse != nil {
                print("Image was NOT cached, fade in image")
                poster.alpha = 0.0
                
                
                poster.image = image
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    poster.alpha = 3.0
                })
            } else {
                print ("Image was cached so just update the image")
                poster.image = image
            }
        },
                            failure: {(imageRequest, imageResponse, error) -> Void in
                                
                                print("Failure to get image")
                                
        })
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

