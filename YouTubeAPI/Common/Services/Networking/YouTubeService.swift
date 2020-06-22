//
//  YouTubeService.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/15/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Moya

enum YouTubeService {
    case getChannelInfo(token: String, channelsId: [String])
    case getChannelUploads(token: String, channelId: String)
    case getPlaylist(token: String, playlistId: String)
    case getVideolist(token: String, videoIds: [String])
}

extension YouTubeService: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com/youtube/v3")!
    }
    
    var path: String {
        switch self {
        case .getChannelInfo:
            return "/channels"
        case .getChannelUploads(_, let id):
            return "/lesson_marathons/\(id)"
        case .getPlaylist:
            return "/playlistItems"
        case .getVideolist:
            return "/videos"
        }
    }
    
    var method: Method {
        switch self {
        case .getChannelInfo, .getChannelUploads, .getPlaylist, .getVideolist:
            return .get
        }
    }
    
    var sampleData: Data { return Data() }
    
    var task: Task {
        switch self {
        case .getChannelInfo(let token, let id):
            let idString = id.joined(separator: ",")
            let escapedIdString = idString
            let escapedPart = "statistics,brandingSettings,contentDetails"
            let params: [String: Any] = ["part": escapedPart, "id": escapedIdString, "key": token]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getPlaylist(let token, let id):
            let params: [String: Any] = ["part": "contentDetails", "playlistId": id, "maxResults": 10, "key": token]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getVideolist(let token, let id):
            let idString = id.joined(separator: ",")
            let params: [String: Any] = ["part": "statistics,snippet,contentDetails", "id": idString, "maxResults": 10, "key": token]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getChannelUploads:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let headers = ["Accept": "application/json", "Content-Type": "application/json"]
        return headers
    }
    
}

