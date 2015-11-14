//
//  SrtParser.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 13..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import Foundation

// http://stackoverflow.com/a/11659306

struct SrtCard {
    var number:Int;
    var startTime:Int64;
    var stopTime:Int64;
    var text:String
}

class SrtParser {
    static let STATE_SUBNUMBER = 0
    static let STATE_TIME = 1
    static let STATE_TEXT = 2
    
    private var state:Int
    private var cards:[(SrtCard)]
    private var number:Int
    private var time:String
    private var text:String
    
    init(text: String) {
        self.state  = SrtParser.STATE_SUBNUMBER
        self.cards  = []
        self.number = 0
        self.time   = ""
        self.text   = ""
        
        parse(text)
    }
    
    func timeToInt(time: String) -> Int64 {
        let a = Array(time.characters)
        
        let hour = Int(String(a[0...1]))! * 60 * 60
        let min = Int(String(a[3...4]))! * 60
        let sec = Int(String(a[6...7]))!
        let msec = Int(String(a[9...11]))!
        
        return Int64(((hour + min + sec) * 1000) + msec)
    }
    
    func parse(text: String) {
        let text = text.stringByReplacingOccurrencesOfString("\r", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let lines = text.componentsSeparatedByString("\n")
        for var line in lines {
            line = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            switch self.state {
            case SrtParser.STATE_SUBNUMBER:
                if (!line.isEmpty) {
                    self.number = Int(line)!
                    self.state = SrtParser.STATE_TIME
                }
                break;
            case SrtParser.STATE_TIME:
                self.time = line;
                self.state = SrtParser.STATE_TEXT
                break;
            case SrtParser.STATE_TEXT:
                if (!line.isEmpty) {
                    self.text += line;
                } else {
                    let times = self.time.componentsSeparatedByString(" --> ")
                    self.cards.append(SrtCard(number: self.number, startTime: timeToInt(times[0]), stopTime: timeToInt(times[1]), text: self.text))
                    self.text  = "";
                    self.state = SrtParser.STATE_SUBNUMBER
                }
                break;
            default:
                break;
            }
        }
    }
    
    func getCards() -> [(SrtCard)] {
        return self.cards
    }

}
