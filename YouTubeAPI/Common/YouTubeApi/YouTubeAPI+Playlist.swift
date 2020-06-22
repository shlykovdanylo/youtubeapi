//
//  YouTubeAPI+Playlist.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/18/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Moya

extension BackendAPI {
    
    class Playlist: BaseTokenApi {
        
        private struct PlaylistResponse: Decodable {
            let playlist: [PlaylistItem]
            
            enum CodingKeys: String, CodingKey {
                case playlist = "items"
            }
        }
        
        private let provider = MoyaProvider<YouTubeService>()
        
        func getPlaylist(id: String, onComplete: @escaping () -> Void,
                                  onSuccess: @escaping ([PlaylistItem]) -> Void,
                                  onError: @escaping OnErrorCompletion) {
            
            request = provider.request(.getPlaylist(token: token, playlistId: id), completion: { result in
                onComplete()
                BaseApi.mapResult(result,
                                  intoItemOfType: PlaylistResponse.self,
                                  onSuccess: { messagesResponse in
                                    onSuccess(messagesResponse.playlist)
                },
                                  onError: onError)
            })
        }
        
    }
    
}
