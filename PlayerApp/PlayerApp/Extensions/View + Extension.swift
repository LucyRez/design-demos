//
//  View + Extension.swift
//  PlayerApp
//
//  Created by Lucy Rez on 16.04.2025.
//

import Foundation
import SwiftUI

extension View {
    func customFont(style: CustomFontStyles) -> some View {
        self.modifier(CustomFont(style: style))
    }
    

}


struct CustomFont: ViewModifier {
    let style: CustomFontStyles
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundStyle(style.color)
    }
    
}


enum CustomFontStyles {
    case title
    case subtitle
    case playerTitle
    
    var color: Color {
        switch self {
        case .title:
                .black
        case .subtitle:
                .white
        case .playerTitle:
                .blue
        }
    }
    
    var font: Font {
        switch self {
        case .title:
                .system(size: 16, weight: .regular)
        case .subtitle:
                .system(size: 14, weight: .medium)
        case .playerTitle:
                .system(size: 16, weight: .regular)
        }
    }
    
}
