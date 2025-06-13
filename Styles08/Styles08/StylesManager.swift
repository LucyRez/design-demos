//
//  StylesManager.swift
//  Styles08
//
//  Created by Grigory Sosnovskiy on 22.01.2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let chars = Array(hex)

        let red = Self.charToInt(chars[0]) * 16 + Self.charToInt(chars[1])
        let green = Self.charToInt(chars[2]) * 16 + Self.charToInt(chars[3])
        let blue = Self.charToInt(chars[4]) * 16 + Self.charToInt(chars[5])

        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }

    private static func charToInt(_ char: Character) -> Double {
        switch char.uppercased() {
        case "A":
            return 10
        case "B":
            return 11
        case "C":
            return 12
        case "D":
            return 13
        case "E":
            return 14
        case "F":
            return 15
        default:
            guard let result = Double(String(char)) else {
                assertionFailure("could not turn hex")
                return 0
            }
            return result
        }
    }
}

enum Colors {
    enum Text {
        /// 000000 1
        static let primary = Color(hex: "000000")
    }
}

struct Style: Decodable {
    var name: String
    var backgroundColor: String
    var cornerRadius: CGFloat
}

final class StylesManager {
    func style(for name: String) -> Style? {
        guard
            let path = Bundle.main.path(forResource: "Styles", ofType: "txt"),
            let data = try? String(contentsOfFile: path, encoding: .utf8).data(using: .utf8),
            let styles = try? JSONDecoder().decode([Style].self, from: data)
        else {
            return nil
        }

        for style in styles where style.name == name {
            return style
        }

        return nil
    }
}
