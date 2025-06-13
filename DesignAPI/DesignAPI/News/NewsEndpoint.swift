//
//  NewsEndpoint.swift
//  DesignAPI
//
//  Created by Grigory Sosnovskiy on 11.12.2024.
//

import Foundation

enum NewsEndpoint: Endpoint {
    case newsPage(pageIndex: Int)

    var compositePath: String {
        switch self {
        case .newsPage:
            return "/api/Section"
        }
    }

    var headers: [String: String] {
        return [:]
    }

    var parameters: [String: String]? {
        switch self {
        case .newsPage(let pageIndex):
            return [
                "rubricId": "4",
                "pageSize": "8",
                "pageIndex": "\(pageIndex)"
            ]
        }
    }
}
