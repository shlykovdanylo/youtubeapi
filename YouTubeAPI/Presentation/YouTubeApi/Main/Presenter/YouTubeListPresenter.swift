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
    
    required init(view: View) {
        self.view = view
        
        let token = "AIzaSyCXpUsy4hSuCEfAw_bWbgKlPDV_pb4Fli8"
        channelApi = .init(token: token)
        playlistApi = .init(token: token)
        videolistApi = .init(token: token)
    }
    
    func getChannels(channelsId: [String]) {
        view.disableUserInteraction()
        view.showLoader()
        
        channelApi.getChannels(id: channelsId, onComplete: { [weak self] in
            self?.view.enableUserInteraction()
            self?.view.hideLoader()
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
    
    func getPlayList(playlistId: String) {
        view.disableUserInteraction()
        view.showLoader()
        
        playlistApi.getPlaylist(id: playlistId, onComplete: { [weak self] in
            self?.view.enableUserInteraction()
            self?.view.hideLoader()
        }, onSuccess: { [weak self] items in
            guard let self = self else { return }
            self.getVideolist(videos: items, playlistId: playlistId)
        }) { [weak self] errorText in
            self?.view.showErrorPopup(with: errorText)
        }
    }
    
    func getVideolist(videos: [PlaylistItem], playlistId: String) {
        var videoIds: [String] = []
        for item in videos {
            videoIds.append(item.contentDetails.videoId)
        }
        view.disableUserInteraction()
        view.showLoader()
        
        videolistApi.getVideolist(id: videoIds, onComplete: { [weak self] in
            self?.view.enableUserInteraction()
            self?.view.hideLoader()
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
            self.view.update()
        }) { [weak self] errorText in
            self?.view.showErrorPopup(with: errorText)
        }
    }
    
}
