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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callService()

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callService() {
        
//        let apiKey = "5bf0547b7de4003cc2d3f7365471ee39"
//        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        
//        getJSON(("https://api.themoviedb.org/3/movie/now_playing?api_key=5bf0547b7de4003cc2d3f7365471ee39"), completionHandler: {
//            json in DispatchQueue.main.async {
//                if let movies = json["results"] as? [NSDictionary]{
//                    self.moviesArray = movies
//                    self.tableView.reloadData()
//                } else {
//                    let ac = UIAlertController(title: "UH OH!", message: "Something went wrong, please check internet connection", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//                    self.present(ac, animated: true, completion: nil)
//                    print(json)
//                }
//            }
//        })
//    }
    
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
        let movie = moviesArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.movieTitle.text = movie?["title"] as? String//posts?[indexPath.row]["blog_name"] as! String
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

