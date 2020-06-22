//
//  String+extensions.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/20/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit

extension String {

    func getYoutubeFormattedDuration() -> String {

        let formattedDuration = self.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "H", with:":").replacingOccurrences(of: "M", with: ":").replacingOccurrences(of: "S", with: "")

        let components = formattedDuration.components(separatedBy: ":")
        var duration = ""
        for component in components {
            duration = duration.count > 0 ? duration + ":" : duration
            if component.count < 2 {
                duration += "0" + component
                continue
            }
            duration += component
        }

        return duration

    }
    
    func getSecondsFromDuration() -> Int {
        
        let stringPartsArray = self.components(separatedBy: ":")
        var intArray: [Int] = []
        for var part in stringPartsArray {
            if part.first == "0" {
                part.removeFirst()
            }
            if let intPart = Int(part) {
                intArray.append(intPart)
            }
        }
        intArray.reverse()
        var totalSeconds = 0
        for (index, item) in intArray.enumerated() {
            if index == 0 {
                totalSeconds += item
            } else {
                totalSeconds += item * (60^index)
            }
        }
        
        return totalSeconds
    }

}
