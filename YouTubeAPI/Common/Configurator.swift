//
//  Configurator.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/15/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

class Configurator<V: View, P: Presenter> where P.View == V, V.Presenter == P {
    private let view: V
    
    init(view: V) {
        self.view = view
    }
    
    func configurate() {
        let presenter = P.init(view: view)
        view.presenter = presenter
    }
}
