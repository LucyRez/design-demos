//
//  SelectColorIntent.swift
//  StepperWidgetApp
//
//  Created by Lucy Rez on 12.02.2025.
//

import Foundation
import AppIntents
import SwiftUI


struct SelectColorIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Color Change"
    
    @Parameter(title: "Accent Color")
    var color: WidgetColor
}

struct WidgetColor: AppEntity {
    
    var id: String
    var color: Color
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Color Change"
    
    static var defaultQuery = ColorQuery()
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(stringLiteral: "\(id)")
    }
    
    public static let allColors: [WidgetColor] = [
        WidgetColor(id: "Pink", color: .pink),
        WidgetColor(id: "White", color: .white),
        WidgetColor(id: "Teal", color: .teal),
    ]
    
    
}

struct ColorQuery: EntityQuery {
    
    func entities(for identifiers: [Entity.ID]) async throws -> [WidgetColor] {
        WidgetColor.allColors.filter {
            identifiers.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [WidgetColor] {
        WidgetColor.allColors
    }
    
    func defaultResult() async -> WidgetColor? {
        WidgetColor.allColors.first
    }
    
}
