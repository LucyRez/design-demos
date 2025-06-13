//
//  SwiftUIView.swift
//  
//
//  Created by Lucy Rez on 29.01.2025.
//

import SwiftUI


public struct CardItem {
    let imageName: String
    let text: String
    
    public init(imageName: String, text: String) {
        self.imageName = imageName
        self.text = text
    }
}

public struct SingleCardView: View {
    let cardItem: CardItem
    let delete: () -> Void
    
    @State var cardOffset: CGSize = .zero
    
    public init(cardItem: CardItem, delete: @escaping () -> Void) {
        self.cardItem = cardItem
        self.delete = delete
    }
    
    
    public var body: some View {
        VStack {
            Image(systemName: cardItem.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 500)
            
            Text(cardItem.text)
                .font(.headline)
                .padding()
            
            Button(action: {}, label: {
                
                Image(systemName: "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                
            })
        }
        .padding(25)
        .background(.gray)
        .cornerRadius(20)
        .shadow(radius: 5)
        .offset(cardOffset)
        .rotationEffect(.degrees(Double(cardOffset.width)/8))
        .gesture(
            DragGesture()
                .onChanged {location in
                    if (cardOffset.height < -100 || cardOffset.height > 200 ) {
                        return
                    }
                    
                    cardOffset = location.translation
                }
                .onEnded {location in
                    if (cardOffset.width > 150 || cardOffset.width < -150) {
                        delete()
                    }
                    
                    cardOffset = CGSize(width: 0, height: 0)
                }
        
        )
        .animation(.spring(), value: cardOffset)
        
    }
}
