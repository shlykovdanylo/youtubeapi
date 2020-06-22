//
//  Playlist.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/18/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

struct PlaylistItem: Decodable {
    struct PlaylistContentDetails: Decodable {
        let videoId: String
        
        enum CodingKeys: String, CodingKey {
            case videoId
        }
    }
    
    let contentDetails: PlaylistContentDetails
    
    enum CodingKeys: String, CodingKey {
        case contentDetails
    }
}
