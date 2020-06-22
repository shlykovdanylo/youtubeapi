//
//  PlayerInitializer.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/19/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

class PlayerInitializer: NSObject {
    @IBOutlet weak var viewController: PlayerViewController!
    
    override func awakeFromNib() {
        let configurator = Configurator(view: viewController)
        configurator.configurate()
    }
}
