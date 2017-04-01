//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Brandon Aubrey on 3/29/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitle:          UILabel!
    @IBOutlet weak var MovieDescription:    UILabel!
    @IBOutlet weak var scrollView:          UIScrollView!
    @IBOutlet weak var posterImage:         UIImageView!
    @IBOutlet weak var filmDate:            UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movie?.title
        MovieDescription.text = movie?.description
        filmDate.text = movie?.filmDate
        
        if let pp = movie?.posterPath{
            let baseUrl = "http://image.tmdb.org/t/p/w342\(pp)"
            let imageUrl = NSURL(string: baseUrl)
            posterImage.setImageWith(imageUrl! as URL)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
