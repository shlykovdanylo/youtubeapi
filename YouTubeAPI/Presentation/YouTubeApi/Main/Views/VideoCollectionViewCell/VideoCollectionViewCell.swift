//
//  VideoCollectionViewCell.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/18/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit
import SDWebImage

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var videoViewsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoImageView.layer.cornerRadius = 6
    }
    
    func configure(data: VideoListItem) {
        videoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let imageUrl = data.snippet.thumbnails.standard?.url {
            videoImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        videoNameLabel.text = data.snippet.title
        videoViewsCountLabel.text = data.statistics.viewCount
    }

}
