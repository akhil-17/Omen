//
//  OmenWidget.swift
//  OmenWidget
//
//  Created by Akhil Dakinedi on 3/16/25.
//

import WidgetKit
import SwiftUI

struct NoiseBackground: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .radialGradient(
                    Gradient(colors: [Color(hex: "#191919"), Color(hex: "#000000")]),
                    center: center,
                    startRadius: 0,
                    endRadius: max(size.width, size.height) / 1.5
                )
            )
            
            let noiseScale: CGFloat = 25
            let cells = Int(size.width / noiseScale) * Int(size.height / noiseScale) * 4
            
            for _ in 0..<cells {
                let x = CGFloat.random(in: 0..<size.width)
                let y = CGFloat.random(in: 0..<size.height)
                let rect = CGRect(x: x, y: y, width: 1, height: 1)
                
                let baseOpacity = Double.random(in: 0.08...0.25)
                context.fill(Path(rect), with: .color(.white.opacity(baseOpacity)))
            }
        }
    }
}

struct Provider: TimelineProvider {
    let sharedData = SharedWeatherData.shared
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), haiku: "Through mist and shadow\nYour presence calls to the void\nShare your location", lastUpdated: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), haiku: sharedData.currentHaiku, lastUpdated: sharedData.lastUpdated)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Create entries every 5 minutes for the next 30 minutes
        for minuteOffset in stride(from: 0, to: 30, by: 5) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, haiku: sharedData.currentHaiku, lastUpdated: sharedData.lastUpdated)
            entries.append(entry)
        }

        // Refresh more frequently to catch updates
        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!))
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let haiku: String
    let lastUpdated: Date
}

struct OmenWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.haiku)
            .font(.custom("Optima-Regular", size: 18))
            .foregroundColor(Color(hex: "#d4d4d4"))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .minimumScaleFactor(0.8)
    }
}

struct OmenWidget: Widget {
    let kind: String = "OmenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                OmenWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        NoiseBackground()
                    }
            } else {
                OmenWidgetEntryView(entry: entry)
                    .padding()
                    .background {
                        NoiseBackground()
                    }
            }
        }
        .configurationDisplayName("Omen")
        .description("Weather haikus that pierce the veil.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    OmenWidget()
} timeline: {
    SimpleEntry(date: .now, haiku: "The air turns to flame,\nflesh wilts like a dying leaf.\nThe sun laughs at you.", lastUpdated: Date())
    SimpleEntry(date: .now, haiku: "A tyrant above,\nburning the land with great wrath.\nNo shade shall save you.", lastUpdated: Date())
}
