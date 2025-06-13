//
//  AddSongView.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import SwiftUI
import SwiftData

struct AddSongView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State var lyrics: String = ""
    @State var songTitle: String = ""
    @State var artist: String = ""
    @State var albumCover: String = ""
    
    @State var isLoading: Bool = false
    
    @State var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                if isLoading {
                    ProgressView()
                        .zIndex(1.0)
                }
                
                Form {
                    // Search
                    Section("Search on Genius") {
                        HStack {
                            TextField("Song Title", text: $searchQuery)
                            
                            Button {
                                
                                withAnimation {
                                    isLoading = true
                                }
                            
                                Task {
                                    let song = await NetworkLayer.shared.getSongByTitle(title: searchQuery)
                                    
                                    lyrics = song?.lyrics ?? ""
                                    songTitle = song?.title ?? ""
                                    albumCover = song?.albumCover ?? ""
                                    artist = song?.artist ?? ""
                                   
                                    withAnimation {
                                        isLoading = false
                                    }
                                }
                                
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text("Search")
                                }
                            }
                            
                        }
                        .buttonStyle(.plain)
                       
                    }
                    
                    // Song info
                    Section {
                        TextField("Song Title", text: $songTitle)
                        TextField("Artist", text: $artist)
                        TextField("Album Cover URL", text: $albumCover)
                    }
                    
                    
                    // Lyrics
                    Section("Song Lyrics") {
                        TextEditor(text: $lyrics)
                    }
                    
                    // Save button
                    Section {
                        Button("Save") {
                            modelContext.insert(Song(title: songTitle, artist: artist, albumCover: albumCover, lyrics: lyrics))
                            
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Add Song")
                .blur(radius: isLoading ? 3.0 : 0.0)
            }
            
            }
           
    }
}

#Preview {
    AddSongView()
}
