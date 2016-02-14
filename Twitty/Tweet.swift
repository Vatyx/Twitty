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
    var createdAtString: String?
    var createdAt: NSDate?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        retweet_count = dictionary["retweet_count"] as? Int
        favorites_count = dictionary["favorite_count"] as? Int
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
