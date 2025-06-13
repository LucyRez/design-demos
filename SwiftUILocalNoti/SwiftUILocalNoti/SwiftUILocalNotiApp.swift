//
//  SwiftUILocalNotiApp.swift
//  SwiftUILocalNoti
//
import SwiftUI

enum Settings {
    static let selectedTab = "selectedTab"
}

@main
struct SwiftUILocalNotiApp: App {
//    @State var selectedTab = 0
    @AppStorage(Settings.selectedTab) var selectedTab = 3

    var body: some Scene {
        WindowGroup {
          // Example1()
           myTabView()
        }
    }
}

extension SwiftUILocalNotiApp {
    func myTabView() -> some View {
        TabView(selection: $selectedTab ){
            Example1()
            .tabItem {
                Label("Drop", systemImage: "drop")
            }
            .tag(0)
            
            Example2()
            .tabItem {
                Label("Example 1", systemImage: "01.square")
            }
            .tag(1)
                
            ReminderMessageView()
            .tabItem {
                Label("Reminder", systemImage: "deskclock")
            }
            .tag(2)
                
            SitesView()
            .tabItem {
                Label("Sites", systemImage: "info.circle")
            }
            .tag(3)
        }
    }
}
