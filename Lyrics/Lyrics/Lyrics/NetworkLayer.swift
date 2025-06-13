//
//  NetworkLayer.swift
//  Lyrics
//
//  Created by Lucy Rez on 16.10.2024.
//

import Foundation


class NetworkLayer {
    
    static let shared = NetworkLayer()
    
    func getSongByTitle(title: String) async -> SongResponse? {
        
        let url = "http://127.0.0.1:3000/lyrics/\(title)"
        
        do {
            let (data, _) =  try await URLSession.shared.data(from: URL(string: url)!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let resp = try decoder.decode(SongResponse.self, from: data)
            return resp
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil

    }
}
