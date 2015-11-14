//
//  ShowCell.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 14..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import UIKit

class ShowCell: UICollectionViewCell {
    
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var showLbl: UILabel!
    
    func configureCell(show: ApiResultShow) {
        
        if let title = show.title {
            showLbl.text = title
        }
        
        if let path = show.poster {
            let url = NSURL(string: path)!
            
            dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url)!
                
                dispatch_async(dispatch_get_main_queue()) {
                    let img = UIImage(data: data)
                    self.showImg.image = img
                }
                
            }
        }
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if (self.focused)
        {
            self.showImg.adjustsImageWhenAncestorFocused = true
        }
        else
        {
            self.showImg.adjustsImageWhenAncestorFocused = false
        }
    }
}