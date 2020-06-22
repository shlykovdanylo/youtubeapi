//
//  NetworkingView.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

protocol NetworkingView {
    func disableUserInteraction()
    func enableUserInteraction()
    func showLoader()
    func hideLoader()
}
