//
//  ViewController.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/15/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit
import Moya

class YouTubeListViewController: UIViewController {
    
    var presenter: YouTubeListPresenter<YouTubeListViewController>!
    
    @IBOutlet weak var ytTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ids = ["UCEuOwB9vSL1oPKGNdONB4ig", "UCfM3zsQsOnfWNUppiycmBuw", "UCQjw3b3Ay5zMmEHUAxL93Rw", "UCeekxg1vju_sjIK9KjJJLYg"]
        presenter.getChannels(channelsId: ids)
        presenter.getPlayList(playlistId: "PLN1mxegxWPd3d8jItTyrAxwm-iq-KrM-e")
        presenter.getPlayList(playlistId: "PL3roRV3JHZzYrywUGDSoIeF7J9P4sWIba")
        
        ytTableView.delegate = self
        ytTableView.dataSource = self
        ytTableView.rowHeight = UITableView.automaticDimension
        ytTableView.estimatedRowHeight = 44
        
        ytTableView.register(UINib.init(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: "ChannelTableViewCell")
        ytTableView.register(UINib.init(nibName: "PlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaylistTableViewCell")
        
    }
    
    func openPlayer(videoId: String, playlist: [VideoListItem]) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        
        var allVideoIds: [String] = []
        for item in playlist {
            allVideoIds.append(item.id)
        }
        
        newViewController.presenter.allVideoIds = allVideoIds
        newViewController.presenter.currentVideoId = videoId
        newViewController.presenter.videoList = playlist
        
        self.present(newViewController, animated: true, completion: nil)
    }


}

extension YouTubeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ChannelHeaderTableViewCell", for: indexPath) as! ChannelHeaderTableViewCell
            
            return headerCell
        } else if indexPath.row == 1 {
            let channelsCell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell", for: indexPath) as! ChannelTableViewCell
            
            channelsCell.configure(data: self.presenter.channels)
            
            return channelsCell
        } else if indexPath.row == 2 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "PlaylistHeaderTableViewCell", for: indexPath) as! PlaylistHeaderTableViewCell
            
            return headerCell
        } else if indexPath.row == 3 {
            let playlistCell  = tableView.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell", for: indexPath) as! PlaylistTableViewCell
            
            if let playlist = self.presenter.playlists.first {
                playlistCell.configure(data: playlist)
            }
            
            return playlistCell
        } else if indexPath.row == 4 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "PlaylistHeaderTableViewCell", for: indexPath) as! PlaylistHeaderTableViewCell
            
            return headerCell
        } else {
            let playlistCell  = tableView.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell", for: indexPath) as! PlaylistTableViewCell
            
            playlistCell.changeCellHeight(height: 152)
            if let playlist = self.presenter.playlists.last {
                playlistCell.configure(data: playlist)
            }
            
            return playlistCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PlaylistTableViewCell {
            cell.openVideoTappedCallback = { [weak self] (videoId, allVideoIds) in
                self?.openPlayer(videoId: videoId, playlist: allVideoIds)
            }
        }
        if let cell = cell as? ChannelTableViewCell {
            cell.openUploadsTappedCallback = { [weak self] (channelIndex) in
                guard let playlist = self?.presenter.channelsUploads[channelIndex], let videoId = self?.presenter.channelsUploads[channelIndex].first?.id else {return}
                self?.openPlayer(videoId: videoId, playlist: playlist)
            }
        }
    }
    
}

extension YouTubeListViewController: YouTubeListView {
    func disableUserInteraction() {
        view.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        view.isUserInteractionEnabled = true
    }
    
    func showLoader() {
//        loader.startAnimating()
    }
    
    func hideLoader() {
//        loader.stopAnimating()
    }
    
    func update() {
        ytTableView.reloadData()
    }
}
