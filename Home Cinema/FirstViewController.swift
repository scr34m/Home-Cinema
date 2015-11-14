//
//  FirstViewController.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 13..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var activity:UIActivityIndicatorView!
    var shows:[(ApiResultShow)]!
    var selectedShow:Int!
    
    func loadShows () {
        self.shows  = []
        ApiService.sharedInstance.getShows {JSON, NSError in
            if NSError != nil {
                print(NSError!.debugDescription)
            }
            else {

                for json in JSON.arrayValue {
                    let show = ApiResultShow(fromJson: json);
                    self.shows.append(show)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShowCell", forIndexPath: indexPath) as? ShowCell {
            
            let tvShow = self.shows[indexPath.row]
            cell.configureCell(tvShow)
            
            return cell
        }
        else {
            return ShowCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
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
        return CGSizeMake(260, 430)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadShows()
    }
/*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let playerVC = PlayerViewController()
        playerVC.playVideo()

        [self.presentViewController(playerVC, animated: true, completion: nil)]
    }
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            let vc = segue.destinationViewController as! ShowDetailsViewController
            vc.showInfo = shows[(indexPath?.row)!]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
