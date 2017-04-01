//
//  extension.swift
//  flicks
//
//  Created by Brandon Aubrey on 3/31/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func fadeInImageRequest(imgURL: NSURL) {
        
        let imageRequest = URLRequest(url: imgURL as URL)
        
        self.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: {( imageRequest, imageResponse, image) -> Void in
            
            if imageResponse != nil {
                self.alpha = 0.0
                
                self.image = image
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    self.alpha = 3.0
                })
            } else {
                self.image = image
            }
        }, failure: {(imageRequest, imageResponse, error) -> Void in
            
        })
    }
    
    func loadImagesLowHigh(low: String, high: String) {
        let smallImageRequest = URLRequest(url: URL(string: low)!)
        let largeImageRequest = URLRequest(url: URL(string: high)!)
        
        self.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                self.alpha = 0.0
                self.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    self.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    self.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                
        })
    }
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
