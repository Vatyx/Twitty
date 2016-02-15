//
//  TwitterClient.swift
//  Twitty
//
//  Created by Vatyx on 2/10/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "DxkktSagpvK4ZFSBg1vbj7X8E"
let twitterConsumerSecret = "v4Rv3kayiXF9GL6kIFQH8RUN51cXRrC2byIxaRd2Eq3k1hzulS"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets:tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                print(error)
                completion(tweets: nil, error: error)
        })

    }
    
    func favoriteWithCompletion(id: String?,completion: (error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                print(error)
                completion(error: error)
        })
        
    }
    
    func unfavoriteWithCompletion(id: String?,completion: (error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json?id=\(id!)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                print(error)
                completion(error: error)
        })
        
    }
    
    func retweetWithCompletion(id: String?, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id!).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                print(error)
                completion(error: error)
        })
        
    }
    
    func unretweetWithCompletion(id: String?, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/unretweet/\(id!).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                print(error)
                completion(error: error)
        })
        
    }
    
    func sendTweet(tweet: String, params: NSDictionary?, completion: (response: NSDictionary?,error :NSError?)->()) {
        var parameters = [String: AnyObject]()
        parameters["status"] = tweet
        if let params = params{
            for (key,value) in params{
                parameters[key as! String] = value
            }
        }
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: parameters, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            completion(response: response as? NSDictionary,error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                
                completion(response: nil,error: error)
        }
        
    }
    
    func loginWithCompletion(completion: (user: User?, err: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "Twitty://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got request token.")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            print(authURL)
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error);
        }
    }
    
    func openURL(url: NSURL) {
        print("Inside openURL")
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got Access Token!")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("user: \(response!)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error);
            })
            
            }) { (error: NSError!) -> Void in
                print("failed to recieve access token")
                self.loginCompletion?(user: nil, error: error);
            }
    }
    
}
