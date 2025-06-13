//
//  SongResponse.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import Foundation

struct SongResponse: Codable {
    let title: String
    let artist: String
    let albumCover: String
    let lyrics: String
}
