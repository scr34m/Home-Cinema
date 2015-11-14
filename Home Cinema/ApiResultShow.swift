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
    
    init(fromJson json: JSON!) {
        if (json == nil) {
            return
        }
        title = json["title"].stringValue
        banner = json["banner"].stringValue
        fanart = json["fanart"].stringValue
        poster = json["poster"].stringValue
    }
}


