//
//  SongViewModel.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import Foundation
import AVFoundation

class SongListViewModel: ObservableObject {
    @Published var songs: [Song] = [
    ]
    
    @Published var audioPlayer: AVAudioPlayer?
    
    @Published var isPlaying: Bool = false
    @Published var trackPlaying: Song?
    @Published var currentTime: TimeInterval = 0.0
    @Published var currentIndex = -1
    
    @Published var videoPlayer: AVPlayer?
    @Published var currentVideoUrl: URL?

    
    func play(song: Song) {
        do {
            audioPlayer = try AVAudioPlayer(data: song.data)
            audioPlayer?.play()
            isPlaying = true
            trackPlaying = song
            
            if let index = songs.firstIndex(where: { song.id == $0.id }) {
                currentIndex = index
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func pause() {
        if (isPlaying) {
            audioPlayer?.pause()
            stopVideo()
        } else {
            audioPlayer?.play()
            
            if let currentVideoUrl {
                startVideo(url: currentVideoUrl)
            }
            
        }
        
        isPlaying.toggle()
        
    }
    
    func updateCurrentTime() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime
    }
    
    func setTime(time: TimeInterval) {
        guard let player = audioPlayer else { return }
        player.currentTime = time
    }
    
    func forward() {
        let index = currentIndex == songs.count - 1 ? 0 : currentIndex + 1
        play(song: songs[index])
    }
    
    func backward() {
        let index = currentIndex == 0 ? songs.count - 1 : currentIndex - 1
        play(song: songs[index])
    }
    
    func stopVideo() {
        videoPlayer?.pause()
        videoPlayer = nil
    }
    
    func startVideo(url: URL) {
        currentVideoUrl = url
        videoPlayer = AVPlayer(url: url)
        videoPlayer?.isMuted = true
        videoPlayer?.actionAtItemEnd = .none
        videoPlayer?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem, queue: .main) {[weak self] _ in
            self?.videoPlayer?.seek(to: .zero)
            self?.videoPlayer?.play()
        }
    }
    
    func importSong(_ url: URL) async {
        do {
            let songTrack = try Data(contentsOf: url)
            let songName = url.lastPathComponent
            var song = Song(name: songName, data: songTrack)
            
            let audioAsset = AVURLAsset(url: url)
            
            let metadata = try await audioAsset.load(.metadata)
            
            for item in metadata {
                guard let key = item.commonKey?.rawValue, let value = try await item.load(.value) else { continue }
                
                switch key {
                case AVMetadataKey.commonKeyArtist.rawValue:
                    song.artist = value as? String
                case AVMetadataKey.commonKeyArtwork.rawValue:
                    song.cover = value as? Data
                case AVMetadataKey.commonKeyTitle.rawValue:
                    song.name = value as? String ?? song.name
                default:
                    break;
                }
            }
            
            song.duration = try await CMTimeGetSeconds(audioAsset.load(.duration))
            
            if (!songs.contains(where: { song.name ==  $0.name})) {
                DispatchQueue.main.async {
                    self.songs.append(song)
                }
               
            }

            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
