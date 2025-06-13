//
//  VideoView.swift
//  PlayerApp
//
//  Created by Lucy Rez on 30.04.2025.
//

import SwiftUI
import AVKit

struct VideoView: View {
    
    let url: URL
    @StateObject var vm: SongListViewModel
    
    var body: some View {
        
        GeometryReader { proxy in
            VideoPlayer(player: vm.videoPlayer)
                .disabled(true)
                .onAppear {
                    vm.startVideo(url: url)
                }
                .onDisappear {
                    vm.stopVideo()
                }
                .ignoresSafeArea()
                .frame(width: proxy.size.height * 16 / 9, height: proxy.size.height)
                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        
    }
}
