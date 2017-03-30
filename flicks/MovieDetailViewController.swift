//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Brandon Aubrey on 3/29/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var MovieDescription: UILabel!
    @IBOutlet weak var moviePoster: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movie?.title
        MovieDescription.text = movie?.description
        moviePoster.text = movie?.posterPath
        

        if let pp = movie?.posterPath{
            let baseUrl = "http://image.tmdb.org/t/p/w342\(pp)"
            let imageUrl = NSURL(string: baseUrl)
            posterImage.setImageWith(imageUrl! as URL)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
