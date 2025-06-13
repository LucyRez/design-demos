//
//  MenuView.swift
//  SwiftUILocalNoti
//
import SwiftUI

struct SitesView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: WebView(urlString: "https://ya.ru")){
                    Text("Yandex")
                }
                
                NavigationLink(destination: WebView(urlString: "https://hse.ru")){
                    Text("HSE University")
                }
            }
            .navigationTitle(Text("Sites"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
