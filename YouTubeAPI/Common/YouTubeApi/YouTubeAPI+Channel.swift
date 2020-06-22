//
//  YouTubeAPI+Channel.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Moya

extension BackendAPI {
    
    class Channel: BaseTokenApi {
        
        private struct ChannelResponse: Decodable {
            let channels: [ChannelItem]
            
            enum CodingKeys: String, CodingKey {
                case channels = "items"
            }
            
        }
        
        private let provider = MoyaProvider<YouTubeService>()
        
        func getChannels(id: [String], onComplete: @escaping () -> Void,
                                  onSuccess: @escaping ([ChannelItem]) -> Void,
                                  onError: @escaping OnErrorCompletion) {
            
            request = provider.request(.getChannelInfo(token: token, channelsId: id), completion: { result in
                onComplete()
                BaseApi.mapResult(result,
                                  intoItemOfType: ChannelResponse.self,
                                  onSuccess: { messagesResponse in
                                    onSuccess(messagesResponse.channels)
                },
                                  onError: onError)
            })
        }
        
    }
    
}

extension NetworkActivityPlugin {
    static var `default`: NetworkActivityPlugin {
        return NetworkActivityPlugin { (type, target) in
            switch type {
            case .began:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            case .ended:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
}

