//
//  AddAnimalView.swift
//  PetAppTest
//
//  Created by Lucy Rez on 18.09.2024.
//

import SwiftUI

struct AddAnimalView: View {
    
    @Binding
    var animalsModels: [Animal]
    
    var body: some View {
        ZStack {
            Grid(horizontalSpacing: 64, verticalSpacing: 64){
                GridRow {
                    Text("🐱")
                        .font(.system(size: 42))
                        .onTapGesture {
                            addAnimal(type: "🐱")
                        }
                    Text("🐶")
                        .font(.system(size: 42))
                        .onTapGesture {
                            addAnimal(type: "🐶")
                        }

                }
                
                GridRow {
                    Text("🐹")
                        .font(.system(size: 42))
                        .onTapGesture {
                            addAnimal(type: "🐹")
                        }

                    Text("🐟")
                        .font(.system(size: 42))
                        .onTapGesture {
                            addAnimal(type: "🐟")
                        }

                }
            }
        }
    }
    
    func addAnimal(type: String) {
        print("Test")
        animalsModels.append(Animal(name: "Test", icon: type, color: .icon))
    }
}
