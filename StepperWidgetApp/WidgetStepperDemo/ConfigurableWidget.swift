//
//  ConfigurableWidget.swift
//  StepperWidgetApp
//
//  Created by Lucy Rez on 12.02.2025.
//

import WidgetKit
import SwiftUI

struct ConfigurableProvider: AppIntentTimelineProvider {
 
    func placeholder(in context: Context) -> ConfigurableEntry {
        ConfigurableEntry(date: Date(), stepProgress: DataStorage.shared.progress(), color: .pink)
    }
    
    func snapshot(for configuration: SelectColorIntent, in context: Context) async -> ConfigurableEntry {
        let entry = ConfigurableEntry(date: Date(), stepProgress: DataStorage.shared.progress(), color: configuration.color.color)
        return entry
    }
    
    func timeline(for configuration: SelectColorIntent, in context: Context) async -> Timeline<ConfigurableEntry> {
        var entries: [ConfigurableEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ConfigurableEntry(date: entryDate, stepProgress: DataStorage.shared.progress(), color: configuration.color.color)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
    }

}

struct ConfigurableEntry: TimelineEntry {
    let date: Date
    let stepProgress: Int
    let color: Color
    
}

struct ConfigurableWidgetStepperDemoEntryView : View {
    var entry: ConfigurableProvider.Entry
    
    var body: some View {
        
            ZStack {
                
                
                
                Circle()
                    .stroke(lineWidth: 20)
                    .foregroundColor(.gray)
                    .opacity(0.3)
                
                Circle()
                    .trim(from: 0, to: CGFloat(Double(entry.stepProgress)/100))
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                
                VStack {
                    
                   Button("\(entry.stepProgress)", intent: StepperAppIntent())
                        .font(.largeTitle)
                        .bold()
                }
                    
            }
            .padding(16)
            .background(entry.color)
  
       
    }
}

struct ConfigurableWidgetStepperDemo: Widget {
    let kind: String = "ConfigurableWidgetStepperDemo"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectColorIntent.self, provider: ConfigurableProvider()) { entry in
            
            ConfigurableWidgetStepperDemoEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("My Widget 2")
        .description("This is an example of second widget.")
        .contentMarginsDisabled()
        
    }
}

#Preview(as: .systemSmall) {
    WidgetStepperDemo()
} timeline: {
    SimpleEntry(date: .now, stepProgress: 10)
    SimpleEntry(date: .now, stepProgress: 60)
}

