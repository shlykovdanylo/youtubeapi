//
//  PlaylistTableViewCell.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/18/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playlistCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    
    var videos: [VideoListItem] = []
    
    var openVideoTappedCallback: ((String, [VideoListItem]) -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playlistCollectionView.delegate = self
        playlistCollectionView.dataSource = self
        
        playlistCollectionView.register(UINib.init(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func changeCellHeight(height: CGFloat) {
        collectionViewHeightConst.constant = height
        self.layoutIfNeeded()
    }
    
    func configure(data: [VideoListItem]) {
        videos = data
        playlistCollectionView.reloadData()
    }
    
}

extension PlaylistTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        
        videoCell.configure(data: self.videos[indexPath.row])
        
        return videoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoId = self.videos[indexPath.row].id
        self.openVideoTappedCallback?(videoId, videos)
    }
    
}

extension PlaylistTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.collectionViewHeightConst.constant
        var width: CGFloat = 160
        if height != 117 {
            width = 135
        }
        return CGSize(width: width, height: height)
    }
}
