//
//  OnboardingView.swift
//  LibraryDemoDesignApp
//
//  Created by Lucy Rez on 29.01.2025.
//

import SwiftUI
import Lottie

struct OnboardingPage {
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Test Title", subtitle: "Test subtitle"),
        OnboardingPage(title: "Test Title", subtitle: "Test subtitle"),
        OnboardingPage(title: "Finish onboarding", subtitle: "Long text to show that it is shown correctly"),
    ]
    
    @State private var currentPage = 0
    @Binding var isOnboardingFinished: Bool
    
    var body: some View {
        VStack {
            LottieView(animation: .named("tea1"))
                .playing(loopMode: .loop)
                .frame(width: 300, height: 300)
                .padding(.top, 60)
            
            
            TabView(selection: $currentPage) {
                ForEach(pages.indices) { index in
                    VStack {
                        Text(pages[index].title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text(pages[index].subtitle)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                            .padding(.horizontal, 40)
                        
                        
                        if (currentPage == pages.count - 1) {
                            Button(action: {
                                isOnboardingFinished.toggle()
                            }, label: {
                                Text("Get Started")
                                    .font(.headline)
                                    .padding(.vertical, 28)
                                    .padding(.horizontal, 56)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 50)
                                
                            })
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
        
    }
}
