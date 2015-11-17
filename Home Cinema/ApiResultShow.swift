//
//  ApiResultShows.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 14..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import Foundation

class ApiResultShow {

    var title:String!
    var banner:String!
    var fanart:String!
    var poster:String!
    var overview:String!
    var seasons:[Int]!
    var episodes:[(ApiResultEpisode)]!
    
    init(fromJson json: JSON!) {
        if (json == nil) {
            return
        }
        title = json["title"].stringValue
        banner = json["banner"].stringValue
        fanart = json["fanart"].stringValue
        poster = json["poster"].stringValue
        overview = json["overview"].stringValue
        seasons = []
        for season in json["seasons"].arrayValue {
            seasons.append(season.intValue)
        }
        episodes = []
        for episode in json["episodes"].arrayValue {
            episodes.append(ApiResultEpisode(fromJson: episode))
        }

    }
}


