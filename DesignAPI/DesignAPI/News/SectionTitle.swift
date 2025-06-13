//
//  SectionTitle.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import SwiftUI

struct SectionTitle: View {
    var title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .bold()

            Spacer()
        }
    }
}
