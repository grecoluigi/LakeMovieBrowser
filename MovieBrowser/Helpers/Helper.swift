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
        return durationInMinutes > 59 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}
