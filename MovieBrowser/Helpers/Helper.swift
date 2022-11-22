//
//  Helper.swift
//  MovieBrowser
//
//  Created by Luigi on 18/11/2022.
//

import Foundation

struct Helper {
    static func minutesToMinutesAndHours(durationInMinutes: Int) -> String {
        let hours = durationInMinutes / 60
        let minutes = durationInMinutes % 60
        if minutes == 0 && hours != 0 {
            return "\(hours)h"
        } else {
            return durationInMinutes > 59 ? "\(hours)h \(minutes)m" : "\(minutes)m"
        }
    }
    
    static var coreDataModelName : String {
        return "Movie"
    }
}
