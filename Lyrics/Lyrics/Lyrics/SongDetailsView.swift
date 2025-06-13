//
//  SongDetailsView.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import SwiftUI

struct SongDetailsView: View {
    
    let song: Song
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: song.albumCover)) { image in
                image
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
            }
            
            // Title
            
            Text(song.title)
                .font(.title)
                .fontWeight(.light)
            
            // Artist
            
            Text(song.artist)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            //Lyrics
            
            Text(song.lyrics)
                .padding()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//#Preview {
//    SongDetailsView()
//}
