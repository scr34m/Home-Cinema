//
//  PlayerViewController.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 14..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {

    var subtitleTextView:UITextView!
    var subtitleUrl:String!
    var videoUrl:String!
    var cards:[(SrtCard)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func playVideo() {
        getVideoInfo();
    }

    func getVideoInfo() {
        ApiService.sharedInstance.play {JSON, NSError in
            if NSError != nil {
                print(NSError!.debugDescription)
            }
            else {
                self.subtitleUrl = JSON["subtitle"].stringValue
                self.videoUrl = JSON["video"].stringValue
                self.getSubtitle();
            }
        }
    }
    
    func getSubtitle() {
        ApiService.sharedInstance.rawRequest(self.subtitleUrl) {data, NSError in
            if NSError != nil {
                print(NSError!.debugDescription)
            }
            else {
                let srt = SrtParser(text: NSString(data: data, encoding:NSUTF8StringEncoding ) as String!) // NSASCIIStringEncoding
                self.cards = srt.getCards()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.actualPlayVideo()
                }
            }
        }
    }
    
    func showSubtitle(msg: String) {
        let str = NSAttributedString(string: msg, attributes: [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -4,
            NSFontAttributeName : UIFont.boldSystemFontOfSize(100.0)])
        self.subtitleTextView.attributedText = str
    }
    
    func actualPlayVideo() {
        player = AVPlayer(URL: NSURL(string: self.videoUrl)!)

        // last showed card index in the list
        var cardsIndex = 0
        
        // last shown card number
        var currentCard = -1
        
        player?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 10), queue: dispatch_get_main_queue()) { (CMTime) -> Void in
            let cmt = self.player?.currentTime()
            let time = cmt!.value / 1000000
            
            // create a subset of available cards
            var cardsIndexAhead = self.cards.count - 1;
            if cardsIndex + 10 <= self.cards.count - 1 {
                cardsIndexAhead = cardsIndex + 10
            }
            
            // loop trough the cards subset
            for idx in cardsIndex ... cardsIndexAhead {
                let card = self.cards[idx]
                // hide card if it's the currently showed, but time already past
                if (card.number == currentCard && card.stopTime <= time) {
                    self.showSubtitle("")
                    
                    // invalidate current card number
                    currentCard = -1
                }
                // show card if it is not currenlty showed and between the time window
                if (card.number != currentCard && card.startTime <= time && card.stopTime >= time) {
                    self.showSubtitle(card.text)
                    
                    // store the currenly showed card
                    currentCard = card.number
                    
                    // store the card index for the next subset starting index
                    cardsIndex = idx
                    break
                }
            }
        }

        let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

        subtitleTextView = UITextView(frame: frame)
        self.view.layer.addSublayer(subtitleTextView.layer)
        
        player?.play()
    }

}