//
//  RoundedButton.swift
//  PetAppTest
//
//  Created by Lucy Rez on 18.09.2024.
//

import SwiftUI

struct RoundedButton: View {
    var imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1.0)
                .frame(width: 40, height: 40)
                .foregroundStyle(.gray)
            
            Image(systemName: imageName)
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    RoundedButton(imageName: "leaf")
}
