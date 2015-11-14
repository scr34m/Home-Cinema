//
//  ShowDetailsViewController.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 14..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showOverview: UITextView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var seasonsCollectionView: UICollectionView!

    var showInfo: ApiResultShow!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showTitle.text = showInfo.title
        showOverview.text = showInfo.overview

        if let path = showInfo.poster {
            let url = NSURL(string: path)!
            
            dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url)!
                
                dispatch_async(dispatch_get_main_queue()) {
                    let img = UIImage(data: data)
                    self.bannerImage.image = img
                    self.blur()
                }
                
            }
        }
        
        seasonsCollectionView.delegate = self
        seasonsCollectionView.dataSource = self
        
        seasonsCollectionView.reloadData()
    }

    func blur() {
        let imageView = UIImageView(frame: self.view.bounds);
        imageView.image = bannerImage.image!
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)

        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShowSeasonCell", forIndexPath: indexPath) as? ShowSeasonCell {
            
            let  imageFilename = "posterbackground_.jpg"
            cell.featuredImage.image = UIImage(named: imageFilename)
            
            return cell
        }
        else {
            return ShowSeasonCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 120)
    }
    
}

