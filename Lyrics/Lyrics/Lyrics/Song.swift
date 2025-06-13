//
//  Song.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import Foundation
import SwiftData

@Model
class Song {
    var title: String
    var artist: String
    var albumCover: String
    var lyrics: String
    
    init(title: String, artist: String, albumCover: String, lyrics: String) {
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
        self.lyrics = lyrics
    }
}
