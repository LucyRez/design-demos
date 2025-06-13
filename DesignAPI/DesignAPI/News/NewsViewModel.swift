//
//  NewsViewModel.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import Foundation

final class NewsViewModel: ObservableObject {
    @Published var news: [Article] = []
    @Published var events: [Event] = []

    private let decoder = JSONDecoder()
    private let worker = BaseURLWorker(baseUrl: "https://news.myseldon.com")

    func fetchContent() {
        let request = Request(endpoint: NewsEndpoint.newsPage(pageIndex: 1))
        worker.executeRequest(with: request) { [weak self] result in
            guard let self else {
                print(">>> error: no self")
                return
            }

            switch result {
            case .success(let serverResponse):
                if
                    let data = serverResponse.data,
                    let newsPage = try? decoder.decode(NewsPage.self, from: data)
                {
                    DispatchQueue.main.async {
                        self.news = newsPage.news
                        self.events = newsPage.event
                    }
                } else {
                    print(">>> error: invalid data – \(String(describing: serverResponse.data))")
                }
            case .failure(let error):
                print(">>> error: \(error)")
            }
        }
    }
}
