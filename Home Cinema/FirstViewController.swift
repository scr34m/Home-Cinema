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

    func synchronousRequest(url: String) -> String {
        let url: NSURL! = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var response: NSURLResponse?
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            return NSString(data: data, encoding: NSASCIIStringEncoding) as String!
        } catch (let e) {
            print(e)
        }

        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let srt = SrtParser(text: synchronousRequest("http://localhostarrow.s02e01.hdtv.x264.lol.srt"))
        let cards = srt.getCards()

        let url = NSURL(string: "http://localhost/arrow.s02e01.hdtv.x264.lol.mp4")
        //let url = NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")
        let player = AVPlayer(URL: url!)
        let playerLayer = AVPlayerLayer(player: player)
        
        // last showed card index in the list
        var cardsIndex = 0
        
        // last shown card number
        var currentCard = -1
        
        player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 10), queue: dispatch_get_main_queue()) { (CMTime) -> Void in
            let time = player.currentTime().value / 1000000

            // create a subset of available cards
            var cardsIndexAhead = cards.count - 1;
            if cardsIndex + 10 <= cards.count - 1 {
                cardsIndexAhead = cardsIndex + 10
            }
            
            // loop trough the cards subset
            for idx in cardsIndex ... cardsIndexAhead {
                let card = cards[idx]
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
        
        player.play();
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
