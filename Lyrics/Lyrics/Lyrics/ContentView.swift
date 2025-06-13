//
//  ContentView.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    @State var isAddViewPresented: Bool = false
    
    @Query
    var songs: [Song]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(songs) { someSong in
                    
                    NavigationLink(value: someSong) {
                        VStack(alignment: .leading) {
                            Text(someSong.title)
                                .font(.headline)
                            
                            Text(someSong.artist)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        modelContext.delete(songs[index])
                    }
                })
               
            }
            .navigationTitle("Song List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button("Plus", systemImage: "plus") {
                        isAddViewPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isAddViewPresented) {
                AddSongView()
            }
            .navigationDestination(for: Song.self) { song in
                SongDetailsView(song: song)
            }
        }
       

    }
}

#Preview {
    ContentView()
}
