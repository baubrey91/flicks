//
//  MovieTableViewCell.swift
//  flicks
//
//  Created by Brandon on 3/28/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImage:         UIImageView!
    @IBOutlet weak var movieTitle:          UILabel!
    @IBOutlet weak var movieDescription:    UILabel!
    @IBOutlet weak var tare: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
