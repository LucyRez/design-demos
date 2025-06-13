//
//  TimeInterval + Extension.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import Foundation

extension TimeInterval {
    func convertToString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? "0:00"
    }
}
