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
    @IBOutlet weak var seasonsStackView: UIStackView!
    @IBOutlet weak var episodesLabel: UILabel!
    
    var showInfo: ApiResultShow!
    var episodes: [(ApiResultEpisode)]!
    var seasonButtons: [(UIButton)]!
    
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
        
        seasonButtons = []
        
        var selected = false
        for season in showInfo.seasons {
            let button = UIButton(type: UIButtonType.System)
            button.frame = CGRectMake(0, 0, 50, 50)
            button.setTitle(String(season), forState: UIControlState.Normal)
            button.tag = season
            button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            
            if !selected {
                button.selected = true
                button.tintColor = UIColor.blackColor()
                updateEpisodeList(season)
                selected = true
            }
            
            seasonsStackView.addArrangedSubview(button);
            
            seasonButtons.append(button)
        }
    }
    
    func buttonAction(sender:UIButton!)
    {
        // XXX track already selected button instead
        for button in seasonButtons {
            button.selected = false
            button.tintColor = nil
        }

        sender.selected = true
        sender.tintColor = UIColor.blackColor()

        updateEpisodeList(sender.tag)
    }
    
    func updateEpisodeList(season: Int)
    {
        episodes = []
        for episode in showInfo.episodes {
            if episode.season == season {
                episodes.append(episode)
            }
        }
        
        episodesLabel.text = "Episodes of " + String(season) + " season"
        
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
        return episodes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShowSeasonCell", forIndexPath: indexPath) as? ShowSeasonCell {
            
            let episode = self.episodes[indexPath.row]
            cell.configureCell(episode)
            
            return cell
        }
        else {
            return ShowSeasonCell()
        }
    }

}

