//
//  NewsEventsView.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import SwiftUI

struct NewsEventsView: View {
    private enum Const {
        static let newsTitle: String = "Новости"
        static let eventsTitle: String = "Ивенты"
    }

    @ObservedObject var viewModel: NewsViewModel

    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        viewModel.fetchContent()
    }

    var body: some View {
        VStack {
            SectionTitle(Const.newsTitle)

            TabView {
                ForEach(viewModel.news, id: \.newsId) { article in
                    let model = ArticleModel(
                        id: article.newsId,
                        title: article.title,
                        subtitle: article.announce,
                        imageURL: URL(string: article.img.url),
                        sourceLink: article.sourceLink
                    )

                    NewsCell(model: model)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 270)

            SectionTitle(Const.eventsTitle)

            TabView {
                ForEach(viewModel.events, id: \.id) { event in
                    let model = ArticleModel(
                        id: event.id,
                        title: event.title,
                        subtitle: event.description,
                        imageURL: URL(string: event.img)
                    )

                    NewsCell(model: model)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 350)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    NewsEventsView(viewModel: NewsViewModel())
}
