//
//  DesignAPIApp.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import SwiftUI

@main
struct DesignAPIApp: App {
    var body: some Scene {
        WindowGroup {
            NewsEventsView(viewModel: NewsViewModel())
        }
    }
}
