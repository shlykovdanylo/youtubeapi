//
//  YouTubeListPresenter.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

class YouTubeListPresenter<V: YouTubeListView>: Presenter {
    typealias View = V
    
    weak var view: View!
    private let channelApi: BackendAPI.Channel
    private let playlistApi: BackendAPI.Playlist
    private let videolistApi: BackendAPI.Videolist
    
    var channels: [ChannelItem] = []
    var uploadsPlaylist: [String] = []
    var channelsUploads: [[VideoListItem]] = []
    var playlists: [[VideoListItem]] = []
    
    private let requestsGroup = DispatchGroup()
    
    required init(view: View) {
        self.view = view
        
        let token = "YouTube_Api_token"
        channelApi = .init(token: token)
        playlistApi = .init(token: token)
        videolistApi = .init(token: token)
    }
    
    func getInfo() {
        view.disableUserInteraction()
        view.showLoader()
        
        let ids = ["UCEuOwB9vSL1oPKGNdONB4ig", "UCfM3zsQsOnfWNUppiycmBuw", "UCQjw3b3Ay5zMmEHUAxL93Rw", "UCeekxg1vju_sjIK9KjJJLYg"]
        getChannels(channelsId: ids)
        getPlayList(playlistId: "PLN1mxegxWPd3d8jItTyrAxwm-iq-KrM-e")
        getPlayList(playlistId: "PL3roRV3JHZzYrywUGDSoIeF7J9P4sWIba")
    }
    
    private func getChannels(channelsId: [String]) {
        
        
        channelApi.getChannels(id: channelsId, onComplete: { [weak self] in
            
        }, onSuccess: { [weak self] items in
            guard let self = self else { return }
            
            self.channels = items
            for item in items {
                self.uploadsPlaylist.append(item.contentDetails.relatedPlaylists.uploads)
                self.getPlayList(playlistId: item.contentDetails.relatedPlaylists.uploads)
            }
        }) { [weak self] errorText in
            self?.view.showErrorPopup(with: errorText)
        }
    }
    
    private func getPlayList(playlistId: String) {
        
        playlistApi.getPlaylist(id: playlistId, onComplete: { [weak self] in
            print("request getPlayList() completed")
        }, onSuccess: { [weak self] items in
            guard let self = self else { return }
            
            self.getVideolist(videos: items, playlistId: playlistId)
            
            self.requestsGroup.notify(queue: .main, execute: {
                self.view.enableUserInteraction()
                self.view.hideLoader()
                self.view.update()
            })
            
        }) { [weak self] errorText in
            self?.view.showErrorPopup(with: errorText)
        }
    }
    
    private func getVideolist(videos: [PlaylistItem], playlistId: String) {
        var videoIds: [String] = []
        for item in videos {
            videoIds.append(item.contentDetails.videoId)
        }
        requestsGroup.enter()
        
        videolistApi.getVideolist(id: videoIds, onComplete: { [weak self] in
            print("request getVideolist() completed")
        }, onSuccess: { [weak self] items in
            guard let self = self else { return }
            
            if self.uploadsPlaylist.contains(playlistId) {
                self.channelsUploads.append(items)
                if self.channelsUploads.count == 4 {
                    var newChannelsUploads: [[VideoListItem]] = []
                    for channel in self.channels {
                        for uploads in self.channelsUploads {
                            if uploads.count > 0 {
                                if channel.brandingSettings.channel.title == uploads[0].snippet.channelTitle {
                                    newChannelsUploads.append(uploads)
                                }
                            }
                        }
                    }
                    self.channelsUploads = newChannelsUploads
                }
            } else {
                self.playlists.append(items)
            }
            self.requestsGroup.leave()
        }) { [weak self] errorText in
            self?.view.showErrorPopup(with: errorText)
        }
    }
    
}
