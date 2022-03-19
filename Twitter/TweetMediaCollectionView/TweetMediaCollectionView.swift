//
//  TweetMediaCollectionView.swift
//  Twitter
//
//  Created by Sean Stevens on 3/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetMediaCollectionView: UICollectionView {
    
    var media: [Tweet.Media]!
    
    convenience init() {
        self.init()
        self.media = media
    }
    
    private func configureCollectionView() {

    }
}
