//
//  PlayerPresenter.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/19/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

class PlayerPresenter<V: PlayerView>: Presenter {
    typealias View = V
    
    weak var view: View!
    
    var currentVideoId: String = ""
    var videoList: [VideoListItem] = []
    var allVideoIds: [String] = []
    
    required init(view: View) {
        self.view = view
        
    }
    
}
