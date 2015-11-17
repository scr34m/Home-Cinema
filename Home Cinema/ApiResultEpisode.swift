//
//  ApiResultEpisode.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 17..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import Foundation

class ApiResultEpisode {
    var season:Int!
    var number:Int!
    var title:String!
    var image:String!
    
    init(fromJson json:JSON!) {
        if (json == nil) {
            return
        }
        season = json["season"].intValue
        number = json["season"].intValue
        title = json["title"].stringValue
        image = json["image"].stringValue
    }
}
