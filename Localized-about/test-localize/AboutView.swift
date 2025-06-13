//
//  AboutView.swift
//  test-localize
//
//  Created by brfsu on 22.05.2024.
//

import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var marker: MapMarker
}

let universityCoordinate = CLLocationCoordinate2D(latitude: 55.754070, longitude: 37.648446)

struct AboutView: View {
    var languageCode: String? { Locale.autoupdatingCurrent.language.languageCode?.identifier }
    var localeCode: String? { Locale.autoupdatingCurrent.identifier }
//    var isRussianLanguage: Bool { languageCode == "ru" }
    
    var isRussianLanguage: Bool { locale.language.languageCode!.identifier == "ru" }
    
    var isRussianLocale: Bool { localeCode == "ru_RU" }

    
    
    
    @Environment(\.locale) var locale: Locale
    
    var authors = ["en": ["Egor", "Daniil"],
                   "ru": ["Егор", "Даниил"]]
    
    var lang = { Locale.autoupdatingCurrent.language.languageCode?.identifier }
    
    @State var showingShareSheet = false
    @State var showCopiedMessage = false
    
    let markers = [Marker(marker: MapMarker(coordinate: universityCoordinate, tint: .blue))]
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: universityCoordinate, latitudinalMeters: 250, longitudinalMeters: 250)), annotationItems: markers) { marker in
                marker.marker
            }
                .frame(height: 250)
                .cornerRadius(10)
            
//            Text(String(localized: "Welcome to Tetris AR App"))
//                .padding()
            Text(LocalizedStringKey("WelcomeKey"))
                .padding()
                        
            Spacer()
            
            Text(LocalizedStringKey("This app implements the Tetris game in an AR space."))
                .padding()

//            Text(String(localized: "This app implements the Tetris game in an AR space."))
//                .lineLimit(2)
//                .padding()
            
            Spacer()
            
//            Text(String(localized: "Authors (HSE Students):"))
//                .lineLimit(2)
//                .padding()
            
            Text(LocalizedStringKey("Authors (HSE Students):"))
                .lineLimit(2)
                .padding()
            
            
            ForEach(authors[isRussianLanguage ? "ru" : "en"]!, id: \.self) { author in
                Text(author)
            }
            
            EmailCopyView(email: "advev@hse.ru", showCopiedMessage: $showCopiedMessage)
                .padding()
            Spacer()
            
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 21, height: 29)
                    .padding(.leading, 2)
                Button("Share") {
                    print(locale.language.languageCode!.identifier)
                    showingShareSheet = true
                }
                .sheet(isPresented: $showingShareSheet) {
                    ActivityView(activityItems: [URL(string: "https://gitlab.com/dmalex/tetris-ar-game")!])
                }
            }
        }
    }
}
