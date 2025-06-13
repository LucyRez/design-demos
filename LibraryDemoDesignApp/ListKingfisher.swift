//
//  ListKingfisher.swift
//  LibraryDemoDesignApp
//
//  Created by Lucy Rez on 29.01.2025.
//

import SwiftUI
import Lottie
import Kingfisher

struct ListKingfisher: View {
    
    @State var cacheSize: Result<UInt, KingfisherError>? = nil
    @State var isAlertPresented = false

    var body: some View {
        List {
            Button("Check Cache") {
                KingfisherManager.shared.cache.calculateDiskStorageSize { result in
                   cacheSize = result
                    isAlertPresented.toggle()
                }
            }
            .alert("Disk Cache", isPresented: $isAlertPresented, presenting: cacheSize,
                   actions: { result in
                switch result {
                case .success:
                    Button("Clear") {
                        KingfisherManager.shared.cache.clearCache()
                    }
                    
                    Button("Cancel", role: .cancel) {}
                case .failure:
                    Button("Cancel", role: .cancel) {}
                }
            }, message: {result in
                switch result {
                case .success(let cache):
                  Text("Size: \(Double(cache)/1024/1024) MB")
                case .failure(let error):
                    Text(error.localizedDescription)
                }
            }
            )
            
            
            ForEach(1..<11) { index in
                // download image
                
//                AsyncImage(url: getUrl(index: index)) { image in
//                    image.resizable()
//                        .frame(width: 81, height: 81)
//                } placeholder: {
//         
//                }
//                
                
            
                KFImage(getUrl(index: index))
                    .resizable()
                    .roundCorner(radius: .widthFraction(0.5),
                                 roundingCorners: [.topLeft, .bottomRight])
                    .serialize(as: .JPEG)
                    .frame(width: 400, height: 400)
                    
                
                
                
            }
            
        }
    }
    
    func getUrl(index: Int) -> URL? {
        let url = "https://raw.githubusercontent.com/onevcat/Kingfisher-TestImages/master/DemoAppImage/Loading/kingfisher-\(index).jpg"
    
        return URL(string: url)
        
    }
}

#Preview {
    ListKingfisher()
}
