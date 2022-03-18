//
//  Tweet.swift
//  Twitter
//
//  Created by Sean Stevens on 3/16/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import Foundation

struct Tweet: Identifiable, Codable, Hashable {
    var id: String
    var content: String
    var createdAt: Date
    var user: User
    
    static func initWithDictionary(with data: NSDictionary) -> Self {
        let user = data["user"] as! NSDictionary
        
        return Tweet(
            id: data["id_str"] as! String,
            content: data["text"] as! String,
            createdAt: convertDate(from: data["created_at"] as! String)!,
            user: Tweet.User(
                name: user["name"] as! String,
                screenName: user["screen_name"] as! String,
                profileImageUrl: URL(string: (user["profile_image_url_https"] as! String))!))
    }
}

extension Tweet {
    enum CodingKeys: String, CodingKey {
        case id = "id_str"
        case content = "text"
        case createdAt
        case user
    }
    
    struct User: Codable, Hashable {
        enum CodingKeys: String, CodingKey {
            case name
            case screenName
            case profileImageUrl = "profile_image_url_https"
        }
        
        var name: String
        var screenName: String
        var profileImageUrl: URL
    }
}

extension Tweet {
    private static func convertDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z y"
        
        guard let convertedDate = dateFormatter.date(from: dateString) else {
            print("Unable to convert date")
            return nil
        }
        
        return convertedDate
    }
}
