//
//  SongTileView.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import SwiftUI

struct SongTileView: View {
    
    let song: Song
    
    var body: some View {
        HStack {
            
            if let data = song.cover, let img = UIImage(data: data) {
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            } else {
                Rectangle()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            }
           
            VStack(alignment: .leading) {
                Text(song.name)
                    .customFont(style: .title)
                    .padding(.bottom, 4)
                   
                
                Text(song.artist ?? "Unknown")
                    .customFont(style: .subtitle)
            }
            
            Spacer()
            
            Text(song.duration?.convertToString() ?? "0:00")
            
        }
    }
    

}

#Preview {
    SongTileView(song: Song(name: "Test", data: Data(), artist: "Artist", duration: .random(in: 1...10000)))
}
