//
//  HomeView.swift
//  PetAppTest
//
//  Created by Lucy Rez on 18.09.2024.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            Color.backgroundCustom.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    ProfileView()
                         .padding(16)
                    
                    AnimalCollectionView()
                    
                    AsyncImage(url: URL(string: "https://media.istockphoto.com/id/1443562748/photo/cute-ginger-cat.jpg?s=612x612&w=0&k=20&c=vvM97wWz-hMj7DLzfpYRmY2VswTqcFEKkC437hxm3Cg=")) { image in
                        
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                            .scaledToFill()
            
                    
                    } placeholder: {
                        ProgressView()
                    }
                    
                    
                    
                    
                }
            }
          
            
                 
        }
      
    }
}

#Preview {
    HomeView()
}
