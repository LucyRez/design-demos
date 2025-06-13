//
//  WidgetStepperDemoBundle.swift
//  WidgetStepperDemo
//
//  Created by Lucy Rez on 12.02.2025.
//

import WidgetKit
import SwiftUI

@main
struct WidgetStepperDemoBundle: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        WidgetStepperDemo()
        ConfigurableWidgetStepperDemo()
        
    }
}
