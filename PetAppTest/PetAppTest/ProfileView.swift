//
//  ProfileView.swift
//  PetAppTest
//
//  Created by Lucy Rez on 18.09.2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        HStack(spacing: 16) {
            
            ZStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.icon)
                    .clipShape(.rect(cornerRadius: 8))
                
                Image("Profile")
                
            }
            
            VStack(alignment: .leading) {
                Text("Hi, Oliver!")
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                
                Text("Bangalore, India")
                    .fontWeight(.semibold)
                    .font(.system(size: 12))
                    .opacity(0.4)
            }
            
            Spacer()
            
            RoundedButton(imageName: "magnifyingglass")
            
            RoundedButton(imageName: "bell")

        }
        .padding(16)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    ProfileView()
}
