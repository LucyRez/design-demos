//
//  Models.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import Foundation

// MARK: - NewsPage
struct NewsPage: Decodable {
    let requestId: String
    let news: [Article]
    let event: [Event]
}

// MARK: - Event
struct Event: Decodable {
    let id: Int
    let title: String
    let description: String
    let img: String
}

// MARK: - Article
struct Article: Decodable {
    let newsId: Int
    let img: Img
    let sourceLink: String
    let title: String
    let announce: String
}

// MARK: - Img
struct Img: Decodable {
    let url: String
}

struct ArticleModel {
    var id: Int
    var title: String
    var subtitle: String
    var imageURL: URL?
    var sourceLink: String?
}
