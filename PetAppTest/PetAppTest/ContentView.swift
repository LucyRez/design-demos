//
//  ContentView.swift
//  PetAppTest
//
//  Created by Lucy Rez on 18.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var leafAppears = false
    
    
    var body: some View {
        VStack {
            
            if leafAppears {
                Image(systemName: "leaf")
                    .resizable()
                    .frame(width: 100, height: 100)
                    
            }
            
           
            Button("Tap Me") {
                // action
                // Image appears
                leafAppears.toggle()
               
            }
            
            Text("Hello!")
                .font(.system(size: 24))
                .fontWeight(.regular)
                .foregroundStyle(.cyan)
            
            
            Rectangle()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 18))
            
            
        
          
            
        }
        .animation(.bouncy, value: leafAppears)
        
    }
}

#Preview {
    ContentView()
}
