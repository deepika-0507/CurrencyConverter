//
//  Date+Extension.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 14/01/24.
//

import Foundation

extension Date {
    var isPastThirtyMinutes: Bool {
        let diffInSeconds = Int(self.timeIntervalSinceNow)
        let diffInMinutes = diffInSeconds / 60
        return diffInMinutes < -30
    }
}
