//
//  Tweet.swift
//  Twitty
//
//  Created by Vatyx on 2/10/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var retweet_count: Int?
    var favorites_count: Int?
    var id: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var formatedDate : String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        retweet_count = dictionary["retweet_count"] as? Int
        favorites_count = dictionary["favorite_count"] as? Int
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id_str"] as? String
        print(id)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day], fromDate: createdAt!)

        let month = components.month
        let day = components.day
        formatedDate = "\(month)/\(day)"
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
