//
//  ReminderMessage.swift
//  SwiftUILocalNoti
//
import Foundation

struct ReminderMessage: Codable {
    var date: Date = Date()
    var addToNotfication: Bool = false
    var text: String = "Please water the plant"
}
