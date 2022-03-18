//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Sean Stevens on 3/17/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.isEnabled = false
        tweetTextView.text.removeAll()
        tweetTextView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tweetButton.isEnabled = !tweetTextView.text.isEmpty
    }
    
    @IBAction func onCancelCompose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onPostTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true)
            }, failure: { err in
                print("Error posting tweet: \(err)")
                self.dismiss(animated: true)
            })
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
