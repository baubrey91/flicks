//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Brandon Aubrey on 3/29/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitle:          UILabel!
    @IBOutlet weak var MovieDescription:    UILabel!
    @IBOutlet weak var scrollView:          UIScrollView!
    @IBOutlet weak var posterImage:         UIImageView!
    @IBOutlet weak var filmDate:            UILabel!
    
    var movie: Movie?
    var lowResBase  = "https://image.tmdb.org/t/p/w45"
    var highResBase = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movie?.title
        MovieDescription.text = movie?.description
        filmDate.text = movie?.filmDate
        
        if let pp = movie?.posterPath{
            let lowURL = "\(lowResBase)\(pp)"
            let highURL = "\(highResBase)\(pp)"

            posterImage.loadImagesLowHigh(low: lowURL, high: highURL)
        }
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 1.5
        scrollView.contentSize = CGSize(contentWidth, contentHeight)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
