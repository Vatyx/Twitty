//
//  TweetCell.swift
//  Twitty
//
//  Created by Vatyx on 2/13/16.
//  Copyright © 2016 Vatyx. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteNumber: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    var favorite_ : Bool = false
    var retweet : Bool = false
    
    var tweet: Tweet! {
        didSet {
            var imageURLString = tweet.user?.profileImageURL
            if let index2 = imageURLString!.rangeOfString("normal.png", options: .BackwardsSearch)?.startIndex {
                let sub = imageURLString!.substringToIndex(index2)
                imageURLString = sub + "bigger.png"
            }
            profileImageView.setImageWithURL(NSURL(string: imageURLString!)!)
            
            nameLabel.text = tweet.user!.name!
            screenNameLabel.text = "@\(tweet.user!.screenname!)"
            bodyLabel.text = tweet.text
            timeLabel.text = tweet.formatedDate
            
            favoriteNumber.text = "\(tweet.favorites_count!)"
            retweetLabel.text = "\(tweet.retweet_count!)"
            
            let num = Int(tweet.user!.profile_background_color!, radix: 16)
            let firstColor = hexToColor(num!)
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.colors = [firstColor.CGColor, UIColor.whiteColor().CGColor]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.10, y: 1.0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.viewWithTag(0)!.frame.size.width, height: self.viewWithTag(0)!.frame.size.height + 500)
            //self.viewWithTag(0)?.backgroundColor = UIColor.greenColor()
            self.backgroundView = UIView()
            self.backgroundView!.layer.insertSublayer(gradient, atIndex: 0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let origImage = UIImage(named: "favorite.png");
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        favoriteButton.setImage(tintedImage, forState: .Normal)
        favoriteButton.tintColor = UIColor.grayColor()
        
        let origImage1 = UIImage(named: "retweet.png");
        let tintedImage1 = origImage1?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        retweetButton.setImage(tintedImage1, forState: .Normal)
        retweetButton.tintColor = UIColor.grayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favoriteAction(sender: AnyObject) {
        if !favorite_ {
            
            
            TwitterClient.sharedInstance.favoriteWithCompletion(tweet.id!) { (error) -> () in
                if error == nil {
                    self.favoriteNumber.text = "\(Int(self.favoriteNumber.text!)! + 1)"
                    let origImage = UIImage(named: "favorite.png");
                    let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    self.favoriteButton.setImage(tintedImage, forState: .Normal)
                    self.favoriteButton.tintColor = UIColor.redColor()
                }
            }
            
            favorite_ = true
        }
        else {
            TwitterClient.sharedInstance.unfavoriteWithCompletion(tweet.id!) { (error) -> () in
                if error == nil {
                    self.favoriteNumber.text = "\(Int(self.favoriteNumber.text!)! - 1)"
                    let origImage = UIImage(named: "favorite.png");
                    let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    self.favoriteButton.setImage(tintedImage, forState: .Normal)
                    self.favoriteButton.tintColor = UIColor.grayColor()
                }
            }
            
            favorite_ = false
        }
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
        if !retweet {
            TwitterClient.sharedInstance.retweetWithCompletion(tweet.id!) { (error) -> () in
                if error == nil {
                    self.retweetLabel.text = "\(Int(self.retweetLabel.text!)! + 1)"
                    let origImage1 = UIImage(named: "retweet.png");
                    let tintedImage1 = origImage1?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    self.retweetButton.setImage(tintedImage1, forState: .Normal)
                    self.retweetButton.tintColor = UIColor.greenColor()
                }
            }
            
            retweet = true
        }
        else {
            TwitterClient.sharedInstance.unretweetWithCompletion(tweet.id!) { (error) -> () in
                if error == nil {
                    self.retweetLabel.text = "\(Int(self.retweetLabel.text!)! - 1)"
                    let origImage1 = UIImage(named: "retweet.png");
                    let tintedImage1 = origImage1?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    self.retweetButton.setImage(tintedImage1, forState: .Normal)
                    self.retweetButton.tintColor = UIColor.grayColor()
                }
            }
            
            retweet = false
        }
    }
    
    func toolColor (red: Int, green: Int, blue: Int) -> UIColor {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    func hexToColor (netHex:Int) -> UIColor {
        return toolColor((netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
