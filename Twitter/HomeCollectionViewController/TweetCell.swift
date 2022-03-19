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
            
            if let media = tweet.media {
                if !media.isEmpty { createMediaView(with: media) }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
    }
    
    private func createMediaView(with media: [Tweet.Media]) {
//        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: generateLayout(for: media)!)
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        
//        collectionView.isScrollEnabled = false
//        
//        collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: PhotoItemCell.reuseIdentifier)
//        contentView.addSubview(collectionView)
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

extension TweetCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweet.media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.reuseIdentifier, for: indexPath) as? PhotoItemCell {
            let mediaItem = tweet.media?[indexPath.item]
            

            let photoItem = UIImageView(frame: cell.contentView.bounds)
            photoItem.translatesAutoresizingMaskIntoConstraints = false
            
            photoItem.contentMode = .scaleAspectFill
            photoItem.af_setImage(withURL: mediaItem!.imageUrl, imageTransition: .crossDissolve(0.2))
            cell.addSubview(photoItem)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
    private func generateLayout(for media: [Tweet.Media]) -> UICollectionViewLayout? {
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Single photo case
        let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)))
        fullPhotoItem.contentInsets = insets
        
        let singleItemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)),
            subitem: fullPhotoItem,
            count: 1)
        
        // 2-photo case
        let pairItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1.0)))
        pairItem.contentInsets = insets

        let pairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1/3)),
            subitems: [pairItem, pairItem])
        
        // 3-photo case
        let mainItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = insets

        let pairSupplementaryItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)))
        pairSupplementaryItem.contentInsets = insets

        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)),
          subitem: pairSupplementaryItem,
          count: 2)

        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [mainItem, trailingGroup])
        
        // 4-photo case
        let quadGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)),
            subitems: [pairGroup, pairGroup])
        
        switch media.count {
        case 1:
            print("1 media item")
            
            let section = NSCollectionLayoutSection(group: singleItemGroup)
            return UICollectionViewCompositionalLayout(section: section)
        case 2:
            print("2 media items")
            
            let section = NSCollectionLayoutSection(group: pairGroup)
            return UICollectionViewCompositionalLayout(section: section)
        case 3:
            print("3 media items")
            
            let section = NSCollectionLayoutSection(group: mainWithPairGroup)
            return UICollectionViewCompositionalLayout(section: section)
        case 4:
            print("4 media items")
            
            let section = NSCollectionLayoutSection(group: quadGroup)
            return UICollectionViewCompositionalLayout(section: section)
        default:
            print("Unsupported layout!")
            return nil
        }
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
