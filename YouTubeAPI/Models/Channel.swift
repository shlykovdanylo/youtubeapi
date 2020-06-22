//
//  Channel.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

struct ChannelItem: Decodable {
    let id: String
    let statistics: ChannelStatistics
    let brandingSettings: BrandingSettings
    let contentDetails: ChannelContentDetails
    
    enum CodingKeys: String, CodingKey {
        case id, brandingSettings, statistics, contentDetails
    }
}

struct ChannelContentDetails: Decodable {
    let relatedPlaylists: ChannelRelatedPlaylists
    
    enum CodingKeys: String, CodingKey {
        case relatedPlaylists
    }
}

struct ChannelRelatedPlaylists: Decodable {
    let uploads: String
    
    enum CodingKeys: String, CodingKey {
        case uploads
    }
}

struct BrandingSettings: Decodable {
    struct Channel: Decodable {
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case title
        }
    }
    struct ChannelImage: Decodable {
        let bannerImageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case bannerImageUrl
        }
    }
    
    let channel: Channel
    let image: ChannelImage
    
    enum CodingKeys: String, CodingKey {
        case channel, image
    }
}

struct ChannelStatistics: Decodable {
    let subscriberCount: String
    
    enum CodingKeys: String, CodingKey {
        case subscriberCount
    }
}
