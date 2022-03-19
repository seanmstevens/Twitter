//
//  PhotoItemCell.swift
//  Twitter
//
//  Created by Sean Stevens on 3/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {
    
    var photoItem: UIImageView {
        let imageView = UIImageView(frame: contentView.frame)
        
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    static let reuseIdentifier = "PhotoItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(photoItem)
    }
}
