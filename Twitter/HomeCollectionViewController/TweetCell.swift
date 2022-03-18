//
//  TweetCell.swift
//  Twitter
//
//  Created by Sean Stevens on 3/7/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            profileImageView.makeRounded()
            
            // Configure the cell...
            nameLabel.text = tweet.user.name
            usernameLabel.text = "@" + tweet.user.screenName
            timeLabel.text = getRelativeTimeString(from: tweet.createdAt)
            contentLabel.text = tweet.content
            profileImageView.af_setImage(withURL: tweet.user.profileImageUrl, imageTransition: .crossDissolve(0.2))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        sender.tintColor = UIColor(red: 1/255, green: 186/255, blue: 124/255, alpha: 1)
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        sender.tintColor = UIColor(red: 250/255, green: 24/255, blue: 128/255, alpha: 1)
    }
    
}

extension TweetCell {
    func getRelativeTimeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named
        
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
        return relativeDate
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
