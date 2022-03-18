//
//  HomeCollectionViewController.swift
//  Twitter
//
//  Created by Sean Stevens on 3/6/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeCollectionViewController: UICollectionViewController {
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Tweet>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    private let reuseIdentifier = "TweetCell"
    private lazy var dataSource = makeDataSource()
    
    var tweets = [Tweet]()
    var tweetsToRetrieve = 20
    var requestTimestamp: Date? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbarAppearance()
        configureCollectionView()
        loadTweets(animatingDifferences: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshTimeline()
    }
    
    func applySnapshot(animatingDifferences: Bool = false) {
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(tweets)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = configureLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTimeline), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        collectionView.refreshControl = refreshControl
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, tweet) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.reuseIdentifier,
                    for: indexPath) as? TweetCell
                cell?.tweet = tweet
                
                return cell
            })
        
        return dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tweet = dataSource.itemIdentifier(for: indexPath) else {
          return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Once the user scrolls to halfway through the current collection of tweets, another request
        // should be sent to retrieve older tweets
        if indexPath.item >= (dataSource.snapshot().numberOfItems / 2) {
            // Convert oldest tweet's ID string into a 64-bit integer, then subtract 1. This ensures
            // the tweets we get back are guaranteed to be older than the oldest we have in our
            // collection so far
            let intId = Int64(tweets.last!.id)! - 1
            loadTweets(until: String(intId))
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension HomeCollectionViewController {
    @objc func refreshTimeline() {
        loadTweets(since: tweets.first?.id, animatingDifferences: true)
    }
    
    func loadTweets(
        since minId: String? = nil,
        until maxId: String? = nil,
        animatingDifferences: Bool = false) {
            guard requestTimestamp == nil else {
                return
            }

            let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            var params: [String: Any] = ["count": tweetsToRetrieve]
            
            if let minId = minId {
                params["since_id"] = minId
            } else if let maxId = maxId {
                params["max_id"] = maxId
            }
            
            requestTimestamp = Date()
            TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { tweets in
                var insertPoint = 0
                
                for data in tweets {
                    let tweet = Tweet.initWithDictionary(with: data)
                    
                    if minId != nil {
                        self.tweets.insert(tweet, at: insertPoint)
                        insertPoint += 1
                    } else {
                        self.tweets.append(tweet)
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                }
                self.applySnapshot(animatingDifferences: animatingDifferences)
                self.requestTimestamp = nil
            }, failure: { error in
                print("Could not retrieve tweets: \(error.localizedDescription)")
            })
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "loggedIn")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
    }
}
