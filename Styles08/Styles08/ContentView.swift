//
//  ContentView.swift
//  Styles08
//
//  Created by Grigory Sosnovskiy on 22.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State var styleName = "mainButton"
    var stylesManager = StylesManager()

    var body: some View {
        Button(action: {
            if styleName == "mainButton" {
                styleName = "secondaryButton"
            } else {
                styleName = "mainButton"
            }
        }) {
            Text("Push me")
                .font(.headline)
                .foregroundStyle(Colors.Text.primary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: style(for: styleName).backgroundColor))
                .cornerRadius(style(for: styleName).cornerRadius)
                .padding()
        }
    }

    func style(for name: String) -> Style {
        guard let style = stylesManager.style(for: name) else {
            return Style(name: "", backgroundColor: "000000", cornerRadius: 0)
        }

        return style
    }
}

#Preview {
    ContentView()
}
