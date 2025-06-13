//
//  SongListView.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import SwiftUI

struct SongListView: View {
    @StateObject var vm: SongListViewModel
    @State private var isImporting = false
    @State private var isPlayerFullscreen = false
    
    @Namespace private var playerAnimation
    
    private var coverFrame: CGFloat {
        isPlayerFullscreen ? 300 : 48
    }
    
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                if isPlayerFullscreen, let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4") {
                    VideoView(url: url, vm: vm)
                } else {
                    Color.cyan.opacity(0.4)
                        .ignoresSafeArea()
                }
                
                VStack {
                    List(vm.songs) { song in
                        SongTileView(song: song)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                vm.play(song: song)
                            }
                    }
                    
                    .listStyle(.plain)
                    
                    VStack {
                        if let track = vm.trackPlaying {
                            HStack {
                                if let data = track.cover, let img = UIImage(data: data) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .frame(width: coverFrame, height: coverFrame)
                                        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                                        .opacity(isPlayerFullscreen ? 0.01 : 1)
                                } else {
                                    Rectangle()
                                        .frame(width: coverFrame, height: coverFrame)
                                        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                                        .opacity(isPlayerFullscreen ? 0 : 1)
                                }
                                
                                if !isPlayerFullscreen {
                                    VStack(alignment: .leading) {
                                        Text(track.name)
                                            .customFont(style: .playerTitle)
                                            .padding(.bottom, 4)
                                        
                                        
                                        Text(track.artist ?? "Unknown")
                                            .customFont(style: .subtitle)
                                    }
                                    .matchedGeometryEffect(id: "animate_text", in: playerAnimation)
                                    
                                    Spacer()
                                    
                                    CustomButton(image: !vm.isPlaying ? "play.fill" : "pause.fill", size: .title2, action: vm.pause)
                                }
                            }
                            .padding()
                            .background(isPlayerFullscreen ? .clear : .black.opacity(0.2))
                            .cornerRadius(10)
                            .padding()
                            .onTapGesture {
                                withAnimation(.spring) {
                                    isPlayerFullscreen.toggle()
                                }
                            }
                            
                            
                            if isPlayerFullscreen {
                                VStack {
                                    Text(track.name)
                                        .customFont(style: .playerTitle)
                                        .padding(.bottom, 4)
                                    
                                    
                                    Text(track.artist ?? "Unknown")
                                        .customFont(style: .subtitle)
                                }
                                .matchedGeometryEffect(id: "animate_text", in: playerAnimation)
                                
                                HStack {
                                    Text(vm.currentTime.convertToString())
                                        .customFont(style: .subtitle)
                                    
                                    Spacer()
                                    
                                    Text(track.duration?.convertToString() ?? "0:00")
                                        .customFont(style: .subtitle)
                                }
                                .padding()
                                .padding(.horizontal, 32)
                                .onAppear {
                                    vm.updateCurrentTime()
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                                        vm.updateCurrentTime()
                                    }
                                }
                                
                                Slider(value: $vm.currentTime, in: 0...(track.duration ?? 0)) { editMode in
                                    if !editMode {
                                        vm.setTime(time: vm.currentTime)
                                    }
                                }
                                .tint(.white)
                                .padding(.horizontal, 32)
                                              
                                HStack(spacing: 42) {
                                    CustomButton(image: "backward.fill", size: .title, action: vm.backward)
                                    
                                    CustomButton(image: !vm.isPlaying ? "play.circle.fill" : "pause.circle.fill", size: .largeTitle, action: vm.pause)
                                  
                                    CustomButton(image:  "forward.fill", size: .title, action: vm.forward)
                                }
                            }
                        }
                    }
                    .frame(height: isPlayerFullscreen ? UIScreen.main.bounds.height + 500 : 64)
                    
                }
            }
            
            .toolbar {
                ToolbarItem (placement: .topBarTrailing) {
                    Button {
                        isImporting.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio]) {result in
                switch result {
                case .success(let urlFile):
                    Task {
                        await vm.importSong(urlFile)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    private func CustomButton(image: String, size: Font, action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .font(size)
                .foregroundStyle(.white)
        }
        
    }
}

#Preview {
    SongListView(vm: SongListViewModel())
}
