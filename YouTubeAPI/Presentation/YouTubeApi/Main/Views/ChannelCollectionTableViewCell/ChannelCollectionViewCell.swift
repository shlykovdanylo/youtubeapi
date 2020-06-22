//
//  ChannelCollectionViewCell.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/15/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit
import SDWebImage

class ChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var channelSubsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 4
        bgView.clipsToBounds = true
        
    }
    
    func configure(data: ChannelItem) {
        channelImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        channelImageView.sd_setImage(with: URL(string: data.brandingSettings.image.bannerImageUrl), completed: nil)
        
        channelNameLabel.text = data.brandingSettings.channel.title
        channelSubsCountLabel.text = data.statistics.subscriberCount
    }

}
