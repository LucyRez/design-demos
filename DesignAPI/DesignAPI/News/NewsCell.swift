//
//  NewsCell.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import SwiftUI

struct NewsCell: View {
    var model: ArticleModel

    var body: some View {
        VStack {
            AsyncImage(url: model.imageURL)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 150)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))

            Group {
                Text(model.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(model.subtitle)
                    .font(.caption)
                    .lineLimit(3)
            }
            .padding(.horizontal, 20)

            if let url = URL(string: model.sourceLink ?? "") {
                Link(destination: url) {
                    Text("Читать")
                }
                .padding(.bottom, 50)
            }
        }
    }
}
