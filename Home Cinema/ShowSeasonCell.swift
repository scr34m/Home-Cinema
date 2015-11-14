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