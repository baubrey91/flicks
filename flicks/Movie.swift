//
//  Movie.swift
//  flicks
//
//  Created by Brandon on 3/29/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import Foundation

class Movie {
    var title : String
    var description: String
    var posterPath : String?
    
    init(dict: NSDictionary){
        self.title = dict["title"] as! String
        self.description = dict["overview"] as! String
        self.posterPath = dict["poster_path"] as? String ?? ""

    }
}
