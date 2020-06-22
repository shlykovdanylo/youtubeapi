//
//  Int+extensions.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/20/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import Foundation

extension Int {
    func getTimeFromInt() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let formattedString = formatter.string(from: TimeInterval(self))!
        
        return formattedString
    }
}
