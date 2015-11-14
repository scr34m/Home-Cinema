//
//  FirstViewController.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 13..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    
    var subtitleTextView:UITextView!
    var subtitleUrl:String!
    var videoUrl:String!
    var cards:[(SrtCard)]!
    
    func play() {
        ApiService.sharedInstance.play {JSON, NSError in
            if NSError != nil {
                print(NSError!.debugDescription)
            }
            else {
                self.subtitleUrl = JSON["subtitle"].stringValue
                self.videoUrl = JSON["video"].stringValue
                self.subtitle();
            }
        }
    }
    
    func subtitle() {
        ApiService.sharedInstance.rawRequest(self.subtitleUrl) {data, NSError in
            if NSError != nil {
                print(NSError!.debugDescription)
            }
            else {
                let srt = SrtParser(text: NSString(data: data, encoding:NSUTF8StringEncoding ) as String!) // NSASCIIStringEncoding
                self.cards = srt.getCards()

                dispatch_async(dispatch_get_main_queue()) {
                    self.playVideo()
                }
            }
        }
    }
    
    func playVideo() {
        let player = AVPlayer(URL: NSURL(string: self.videoUrl)!)
        let playerLayer = AVPlayerLayer(player: player)
        
        // last showed card index in the list
        var cardsIndex = 0
        
        // last shown card number
        var currentCard = -1
        
        player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 10), queue: dispatch_get_main_queue()) { (CMTime) -> Void in
            let time = player.currentTime().value / 1000000
            
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
        
        let frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200)
        
        playerLayer.frame = frame
        self.view.layer.addSublayer(playerLayer)
        
        subtitleTextView = UITextView(frame: frame)
        self.view.layer.addSublayer(subtitleTextView.layer)
        
        player.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        play()
    }
    
    func showSubtitle(msg: String) {
        let str = NSAttributedString(string: msg, attributes: [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -4,
            NSFontAttributeName : UIFont.boldSystemFontOfSize(100.0)])
        self.subtitleTextView.attributedText = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
