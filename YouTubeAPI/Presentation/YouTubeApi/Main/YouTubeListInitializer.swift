//
//  YouTubeListInitializer.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/16/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

class YouTubeListInitializer: NSObject {
    @IBOutlet weak var viewController: YouTubeListViewController!
    
    override func awakeFromNib() {
        let configurator = Configurator(view: viewController)
        configurator.configurate()
    }
}
