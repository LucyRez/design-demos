//
//  LyricsApp.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import SwiftUI
import SwiftData

@main
struct LyricsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Song.self)
        
    }
}
