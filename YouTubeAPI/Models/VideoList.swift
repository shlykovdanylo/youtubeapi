//
//  VideoList.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/18/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

struct VideoListItem: Decodable {
    struct VideoSnippet: Decodable {
        struct VideoThumbnails: Decodable {
            struct ThumbnailsUrl: Decodable {
                let url: String
                
                enum CodingKeys: String, CodingKey {
                    case url
                }
            }
            let standard: ThumbnailsUrl?
            
            enum CodingKeys: String, CodingKey {
                case standard
            }
        }
        let title: String
        let channelTitle: String
        let thumbnails: VideoThumbnails
        
        enum CodingKeys: String, CodingKey {
            case title, thumbnails, channelTitle
        }
    }
    
    struct VideoStatistics: Decodable {
        let viewCount: String
        
        enum CodingKeys: String, CodingKey {
            case viewCount
        }
    }
    
    struct VideoContentDetails: Decodable {
        let duration: String
        
        enum CodingKeys: String, CodingKey {
            case duration
        }
    }
    
    let snippet: VideoSnippet
    let statistics: VideoStatistics
    let contentDetails: VideoContentDetails
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case snippet, statistics, contentDetails, id
    }
}
