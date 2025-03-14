//
//  ContentView.swift
//  Wear
//
//  Created by Akhil Dakinedi on 3/10/25.
//

import SwiftUI
import CoreLocation

struct WeatherDetailsOverlay: View {
    let temperature: Double
    let condition: WeatherCondition
    let humidity: Int?
    let windSpeed: Double?
    let precipitation: Double?
    let thunderstormProbability: Int?
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#191919")
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 15) {
                Text("\(Int(temperature))°F")
                    .font(.custom("Optima-Bold", size: 40))
                    .foregroundColor(Color(hex: "#d4d4d4"))
                
                Text(condition.rawValue)
                    .font(.custom("Optima-Regular", size: 24))
                    .foregroundColor(Color(hex: "#d4d4d4"))
                    .padding(.top, 5)
                
                HStack(spacing: 20) {
                    if let humidity = humidity {
                        WeatherDataView(
                            value: "\(humidity)%",
                            label: "Humidity"
                        )
                    }
                    
                    if let windSpeed = windSpeed {
                        WeatherDataView(
                            value: String(format: "%.1f mph", windSpeed),
                            label: "Wind"
                        )
                    }
                    
                    if let precipitation = precipitation {
                        WeatherDataView(
                            value: String(format: "%.1f mm", precipitation),
                            label: "Rain"
                        )
                    }
                    
                    if let thunderstormProb = thunderstormProbability,
                       thunderstormProb > 30 {
                        WeatherDataView(
                            value: "\(thunderstormProb)%",
                            label: "Thunder"
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct AnimatedText: View {
    let text: String
    @State private var characterOpacities: [Double] = []
    let onAnimationComplete: () -> Void
    
    var body: some View {
        Text(text)
            .font(.system(size: 48))
            .foregroundColor(Color(hex: "#d4d4d4"))
            .opacity(characterOpacities.isEmpty ? 0 : 1)
            .onAppear {
                animateText()
            }
    }
    
    private func animateText() {
        let characters = Array(text)
        characterOpacities = Array(repeating: 0, count: characters.count)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeIn(duration: 0.8)) {
                characterOpacities = Array(repeating: 1, count: characters.count)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                onAnimationComplete()
            }
        }
    }
}

struct AnimatedTextLines: View {
    let text: String
    @State private var lineOpacities: [Double] = []
    @State private var debugText: String = ""
    
    var body: some View {
        let lines = text.components(separatedBy: .newlines)
        print("Number of lines: \(lines.count)")
        print("Lines: \(lines)")
        print("Line opacities: \(lineOpacities)")
        
        return VStack(alignment: .leading, spacing: 24) {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                Text(line)
                    .font(.custom("Optima-Regular", size: 48))
                    .foregroundColor(Color(hex: "#d4d4d4"))
                    .opacity(lineOpacities[safe: index] ?? 0)
                    .onAppear {
                        print("Line \(index) appeared: \(line)")
                        animateLine(at: index, in: lines)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: text) { oldValue, newValue in
            print("Text changed from: \(oldValue) to: \(newValue)")
            startAnimation(for: newValue)
        }
        .onAppear {
            print("AnimatedTextLines appeared with text: \(text)")
            startAnimation(for: text)
        }
    }
    
    private func startAnimation(for text: String) {
        let lines = text.components(separatedBy: .newlines)
        print("Starting animation with \(lines.count) lines")
        lineOpacities = Array(repeating: 0, count: lines.count)
        
        // Animate each line with a delay
        for (index, _) in lines.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2.3) {
                withAnimation(.easeIn(duration: 0.8)) {
                    if index < lineOpacities.count {
                        print("Animating line \(index)")
                        lineOpacities[index] = 1
                    }
                }
            }
        }
    }
    
    private func animateLine(at index: Int, in lines: [String]) {
        print("Preparing to animate line \(index)")
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2.3) {
            withAnimation(.easeIn(duration: 0.8)) {
                if index < lineOpacities.count {
                    print("Setting opacity for line \(index) to 1")
                    lineOpacities[index] = 1
                }
            }
        }
    }
}

// Helper extension for safe array access
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingDetails = false
    @State private var currentWeatherMessage: String = ""
    @State private var messageOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#191919")
                .ignoresSafeArea()
            
            // Main Content
            VStack {
                if let locationError = locationManager.error {
                    VStack(spacing: 12) {
                        Text(locationError.message)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#d4d4d4"))
                            .multilineTextAlignment(.center)
                        
                        Button("Open Settings") {
                            locationManager.openSettings()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if let error = weatherService.error {
                    Text(error.localizedDescription)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#d4d4d4"))
                        .multilineTextAlignment(.center)
                        .padding()
                } else if let temperature = weatherService.currentTemperature,
                          let condition = weatherService.weatherCondition {
                    AnimatedTextLines(text: currentWeatherMessage)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .opacity(isShowingDetails ? 0 : 1)
                        .animation(
                            isShowingDetails ? 
                                .easeOut(duration: 0.3) : // Fade out
                                .easeIn(duration: 0.2),   // Faster fade in
                            value: isShowingDetails
                        )
                        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: .infinity, pressing: { isPressing in
                            withAnimation(
                                isPressing ?
                                    .easeInOut(duration: 0.4) :     // Smooth appearance
                                    .easeInOut(duration: 0.25)       // Faster disappearance
                            ) {
                                isShowingDetails = isPressing
                            }
                        }, perform: { })
                } else {
                    Text("Loading...")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#d4d4d4"))
                }
            }
            .padding(.horizontal)
            
            // Overlay
            if isShowingDetails,
               let temperature = weatherService.currentTemperature,
               let condition = weatherService.weatherCondition {
                WeatherDetailsOverlay(
                    temperature: temperature,
                    condition: condition,
                    humidity: weatherService.humidity,
                    windSpeed: weatherService.windSpeed,
                    precipitation: weatherService.precipitation,
                    thunderstormProbability: weatherService.thunderstormProbability
                )
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 1.02)).animation(.easeOut(duration: 0.4)),
                        removal: .opacity.combined(with: .scale(scale: 1.02)).animation(.easeIn(duration: 0.25))
                    )
                )
            }
        }
        .task {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.location) { oldValue, newValue in
            if let location = newValue {
                Task {
                    await weatherService.fetchWeather(for: location)
                }
            }
        }
        .onChange(of: weatherService.weatherCondition) { oldValue, newValue in
            if let condition = newValue {
                print("Weather condition changed to: \(condition.rawValue)")
                messageOpacity = 0 // Reset opacity
                currentWeatherMessage = WeatherMessages.randomMessage(for: condition)
                print("New message: \(currentWeatherMessage)")
                withAnimation(.easeIn(duration: 0.5)) {
                    messageOpacity = 1 // Fade in the new message
                }
            }
        }
    }
}

struct WeatherDataView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.custom("Optima-Regular", size: 16))
                .foregroundColor(Color(hex: "#d4d4d4"))
            Text(label)
                .font(.custom("Optima-Regular", size: 12))
                .foregroundColor(Color(hex: "#d4d4d4").opacity(0.7))
        }
    }
}

// Extension to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
