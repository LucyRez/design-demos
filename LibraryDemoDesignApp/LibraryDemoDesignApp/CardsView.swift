//
//  CardsView.swift
//  LibraryDemoDesignApp
//
//  Created by Lucy Rez on 29.01.2025.
//

import SwiftUI
import CardLib

struct CardsView: View {
    @State var cards: [CardItem] = [
        CardItem(imageName: "heart", text: "dlfhksdjhf"),
        CardItem(imageName: "star" , text: "dksfhgjhgfd"),
        CardItem(imageName: "leaf" , text: "ds,jgfkjs")
    ]
    
    var body: some View {
        ZStack {
            ForEach(cards.indices.reversed(), id: \.self) { index in
                SingleCardView(cardItem: cards[index], delete: {
                    cards.remove(at: index)
                })
            }
        }
    }
}

#Preview {
   CardsView()
}
