//
//  AnimalCollectionView.swift
//  PetAppTest
//
//  Created by Lucy Rez on 18.09.2024.
//

import SwiftUI

struct AnimalCollectionView: View {
    
    @State
    var animalsModels = [
        Animal(name: "River", icon: "🐶", color: .blue),
        Animal(name: "Sky", icon: "🐱", color: .green),
        Animal(name: "Blue", icon: "🐟", color: .purple),
        Animal(name: "Ginger", icon: "🐹", color: .orange),
    
    ]
    
    @State
    var presentation = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Your Pets")
                Spacer()
                Text("See all")
            }
            .padding(16)
            
            ScrollView(.horizontal) {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.icon)
                            .clipShape(.rect(cornerRadius: 8))
                        
                        Text("+")
                            .font(.system(size: 30))
                        
                    }
                    .onTapGesture {
                        animalsModels.append(Animal(name: "Steve", icon: "🐟", color: .blue))
                        
                        presentation.toggle()
                        print("Tap on plus")
                    }
                    .sheet(isPresented: $presentation) {
                        AddAnimalView(animalsModels: $animalsModels)
                    }
                    
                    ForEach(animalsModels, id: \.self) {animal in
                        ZStack {
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(animal.color)
                                .clipShape(.rect(cornerRadius: 8))
                            
                            Text(animal.icon)
                                .font(.system(size: 30))
                                .rotationEffect(.degrees(30))
                            
                        }
                    }
                    
                    
                    
                }

            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        

        }

        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .padding(16)
    }
}

#Preview {
    AnimalCollectionView()
}
