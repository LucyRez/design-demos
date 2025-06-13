//
//  DataStorage.swift
//  StepperWidgetApp
//
//  Created by Lucy Rez on 12.02.2025.
//

import Foundation
import SwiftUI

class DataStorage {
    
    @AppStorage("Test", store: UserDefaults(suiteName: "group.hse.stepper"))
    private var steps: Int = 0
    
    public static let shared = DataStorage()
    
    private init() {
        
    }
    
    func add() {
        steps += 1
    }
    
    func progress() -> Int {
        return steps
    }
    
    
}
