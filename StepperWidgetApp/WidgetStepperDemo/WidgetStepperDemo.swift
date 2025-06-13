//
//  WidgetStepperDemo.swift
//  WidgetStepperDemo
//
//  Created by Lucy Rez on 12.02.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), stepProgress: DataStorage.shared.progress())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), stepProgress: DataStorage.shared.progress())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, stepProgress: DataStorage.shared.progress())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let stepProgress: Int
    
}

struct WidgetStepperDemoEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall, .systemMedium, .systemLarge:
            ProgressCircle(stepProgress: entry.stepProgress, lineWidth: 20)
            .padding(8)
        case .accessoryCircular:
            ProgressCircle(stepProgress: entry.stepProgress, lineWidth: 10)

        @unknown default:
            Text("Error")
        }
       
    }
}

struct WidgetStepperDemo: Widget {
    let kind: String = "WidgetStepperDemo"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetStepperDemoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetStepperDemoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        
    }
}

#Preview(as: .systemSmall) {
    WidgetStepperDemo()
} timeline: {
    SimpleEntry(date: .now, stepProgress: 10)
    SimpleEntry(date: .now, stepProgress: 60)
}
