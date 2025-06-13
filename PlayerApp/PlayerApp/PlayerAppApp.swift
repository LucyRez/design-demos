//
//  PlayerAppApp.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import SwiftUI

@main
struct PlayerAppApp: App {
    var body: some Scene {
        WindowGroup {
            SongListView(vm: SongListViewModel())
        }
    }
}
