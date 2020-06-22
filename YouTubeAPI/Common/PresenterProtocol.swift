//
//  PresenterProtocol.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/15/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

protocol Presenter: AnyObject {
    associatedtype View
    var view: View! { get }
    init(view: View)
}
