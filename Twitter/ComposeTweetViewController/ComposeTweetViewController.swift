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
    @IBOutlet weak var tweetTextView: ComposeTextView!
    @IBOutlet weak var charactersRemainingLabel: UILabel!
    
    private let characterLimit = 280
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.isEnabled = false
        tweetTextView.text.removeAll()
        charactersRemainingLabel.text = characterLimit.description
        tweetTextView.placeholder = "What's happening?"
        tweetTextView.delegate = self
        
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= characterLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let charactersRemaining = characterLimit - tweetTextView.text.count
        
        if charactersRemaining <= 20 {
            charactersRemainingLabel.textColor = .twitterRed
        } else {
            charactersRemainingLabel.textColor = .twitterGray
        }
        
        charactersRemainingLabel.text = charactersRemaining.description
        
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
