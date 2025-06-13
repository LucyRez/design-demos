//
//  StepperAppIntent.swift
//  StepperWidgetApp
//
//  Created by Lucy Rez on 12.02.2025.
//

import Foundation
import AppIntents
import WidgetKit

struct StepperAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Add step"
    static var description: IntentDescription? = IntentDescription(stringLiteral: "This action adds step to the counter widget")
    
    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let dataStorage = DataStorage.shared
        dataStorage.add()
        
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result(value: dataStorage.progress())
    }
    
}
