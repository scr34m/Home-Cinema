//
//  ShowSeasonCell.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 14..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import UIKit

class ShowSeasonCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!

    func configureCell(episode: ApiResultEpisode) {
        
        if let title = episode.title {
            episodeLabel.text = title
        }

        if let path = episode.image {
            let url = NSURL(string: path)!
            
            dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url)!
                
                dispatch_async(dispatch_get_main_queue()) {
                    let img = UIImage(data: data)
                    self.featuredImage.image = img
                }
                
            }
        }
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if (self.focused)
        {
            self.featuredImage.adjustsImageWhenAncestorFocused = true
        }
        else
        {
            self.featuredImage.adjustsImageWhenAncestorFocused = false
        }
    }
}