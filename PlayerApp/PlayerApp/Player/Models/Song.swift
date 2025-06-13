//
//  Song.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import Foundation


struct Song: Identifiable {
    let id: UUID = UUID()
    var name: String
    let data: Data
    var artist: String?
    var cover: Data?
    var duration: TimeInterval?
    
}
