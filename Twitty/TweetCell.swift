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
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            var imageURLString = tweet.user?.profileImageURL
            let index2 = imageURLString!.rangeOfString("normal.png", options: .BackwardsSearch)?.startIndex;
            let sub = imageURLString!.substringToIndex(index2!)
            imageURLString = sub + "bigger.png"
            profileImageView.setImageWithURL(NSURL(string: imageURLString!)!)
            
            nameLabel.text = tweet.user!.name!
            screenNameLabel.text = "@\(tweet.user!.screenname!)"
            bodyLabel.text = tweet.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let origImage = UIImage(named: "favorite.png");
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        favoriteButton.setImage(tintedImage, forState: .Normal)
        favoriteButton.tintColor = UIColor.redColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
