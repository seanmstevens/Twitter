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
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user.name
            usernameLabel.text = "@" + tweet.user.screenName
            timeLabel.text = getRelativeTimeString(from: tweet.createdAt)
            contentLabel.text = tweet.content
            profileImageView.af_setImage(withURL: tweet.user.profileImageUrl, imageTransition: .crossDissolve(0.2))
            profileImageView.makeRounded()
            
            setRetweetButtonAppearance()
            setFavoriteButtonAppearance()
        }
    }
    
    convenience init(with tweet: Tweet) {
        self.init()
        self.tweet = tweet
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        if tweet.retweeted {
            TwitterAPICaller.client?.unretweetTweet(tweetId: tweet.id, success: {
                self.tweet.retweeted.toggle()
                self.tweet.retweetCount -= 1
            }, failure: { error in
                print("Unable to retweet tweet: \(error.localizedDescription)")
            })
        } else {
            TwitterAPICaller.client?.retweetTweet(tweetId: tweet.id, success: {
                self.tweet.retweeted.toggle()
                self.tweet.retweetCount += 1
            }, failure: { error in
                print("Unable to retweet tweet: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        if tweet.favorited {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweet.id, success: {
                self.tweet.favorited.toggle()
                self.tweet.favoriteCount -= 1
            }, failure: { error in
                print("Unable to unfavorite tweet: \(error.localizedDescription)")
            })
        } else {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweet.id, success: {
                self.tweet.favorited.toggle()
                self.tweet.favoriteCount += 1
            }, failure: { error in
                print("Unable to favorite tweet: \(error.localizedDescription)")
            })
        }
    }
    
    func setRetweetButtonAppearance() {
        var symbolConfiguration: UIImage.SymbolConfiguration
        
        if tweet.retweeted {
            symbolConfiguration = .init(weight: .bold)
            retweetButton.tintColor = .twitterGreen
            retweetCountLabel.textColor = .twitterGreen
        } else {
            symbolConfiguration = .init(weight: .regular)
            retweetButton.tintColor = .twitterGray
            retweetCountLabel.textColor = .twitterGray
        }
        
        retweetButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        retweetCountLabel.text = String(tweet.retweetCount)
    }
    
    func setFavoriteButtonAppearance() {
        if tweet.favorited {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .twitterRed
            favoriteCountLabel.textColor = .twitterRed
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .twitterGray
            favoriteCountLabel.textColor = .twitterGray
        }
        
        favoriteCountLabel.text = String(tweet.favoriteCount)
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
