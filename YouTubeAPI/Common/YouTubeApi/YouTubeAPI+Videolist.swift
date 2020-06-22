//
//  YouTubeAPI+Videolist.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/18/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Moya

extension BackendAPI {
    
    class Videolist: BaseTokenApi {
        
        private struct VideolistResponse: Decodable {
            let videolist: [VideoListItem]
            
            enum CodingKeys: String, CodingKey {
                case videolist = "items"
            }
        }
        
        private let provider = MoyaProvider<YouTubeService>()
        
        func getVideolist(id: [String], onComplete: @escaping () -> Void,
                                  onSuccess: @escaping ([VideoListItem]) -> Void,
                                  onError: @escaping OnErrorCompletion) {
            
            request = provider.request(.getVideolist(token: token, videoIds: id), completion: { result in
                onComplete()
                BaseApi.mapResult(result,
                                  intoItemOfType: VideolistResponse.self,
                                  onSuccess: { messagesResponse in
                                    onSuccess(messagesResponse.videolist)
                },
                                  onError: onError)
            })
        }
        
    }
    
}
