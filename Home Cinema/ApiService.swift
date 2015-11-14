//
//  ApiService.swift
//  Home Cinema
//
//  Created by Gyorvari Gabor on 2015. 11. 14..
//  Copyright © 2015. Gyorvari Gabor. All rights reserved.
//

import Foundation

let API_URL = "http://localhost:8000"

class ApiService {
    
    static let sharedInstance = ApiService()
    
    func getRequest(path: String, onCompletion: (JSON, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }
    
    func play(onCompletion: (JSON, NSError?) -> Void) {
        getRequest(API_URL + "/play", onCompletion: { json, err in
            onCompletion(json as JSON, err as NSError?)
        })
    }
    
    func getShows(onCompletion: (JSON, NSError?) -> Void) {
        getRequest(API_URL + "/shows.json", onCompletion: { json, err in
            onCompletion(json as JSON, err as NSError?)
        })
    }
    
    func rawRequest(path: String, onCompletion: (NSData, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            onCompletion(data!, error)
        })
        task.resume()
    }

}