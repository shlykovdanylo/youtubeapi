//
//  ViewProtocol.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/15/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

protocol View: AnyObject {
    associatedtype Presenter
    var presenter: Presenter! { get set }
}
