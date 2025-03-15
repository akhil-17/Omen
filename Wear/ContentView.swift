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
            NoiseBackground()
                .ignoresSafeArea()
            
            // Content
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 0) {
                    Text("Feels like ")
                        .font(.custom("Optima-Regular", size: 48))
                    Text("\(Int(temperature))°F")
                        .font(.custom("Optima-Bold", size: 48))
                }
                .foregroundColor(Color(hex: "#d4d4d4"))
                
                if let humidity = humidity {
                    HStack(spacing: 0) {
                        Text("Humidity ")
                            .font(.custom("Optima-Regular", size: 28))
                        Text("\(humidity)%")
                            .font(.custom("Optima-Bold", size: 28))
                    }
                    .foregroundColor(Color(hex: "#d4d4d4"))
                }
                
                if let windSpeed = windSpeed {
                    HStack(spacing: 0) {
                        Text("Wind ")
                            .font(.custom("Optima-Regular", size: 28))
                        Text(String(format: "%.1f mph", windSpeed))
                            .font(.custom("Optima-Bold", size: 28))
                    }
                    .foregroundColor(Color(hex: "#d4d4d4"))
                }
                
                if let precipitation = precipitation {
                    HStack(spacing: 0) {
                        Text("Rain ")
                            .font(.custom("Optima-Regular", size: 28))
                        Text(String(format: "%.1f mm", precipitation))
                            .font(.custom("Optima-Bold", size: 28))
                    }
                    .foregroundColor(Color(hex: "#d4d4d4"))
                }
                
                HStack(spacing: 20) {
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
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .padding(.horizontal)
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
    var onAnimationComplete: (() -> Void)?
    
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
                
                // If this is the last line, call the completion handler after its animation
                if index == lines.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        onAnimationComplete?()
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

struct NoiseBackground: View {
    @State private var time: Double = 0
    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TimelineView(.animation) { timeline in
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
                    
                    // Use time to create a flickering effect
                    let flickerSpeed = sin(time * 3 + x + y)
                    let baseOpacity = Double.random(in: 0.08...0.25)
                    let opacity = baseOpacity * (flickerSpeed + 1) / 2 // Normalize to 0-1 range
                    
                    // Only draw particles that have sufficient opacity
                    if opacity > 0.02 {
                        context.fill(Path(rect), with: .color(.white.opacity(opacity)))
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            time += 1/60
        }
    }
}

struct LocationPermissionView: View {
    let onRequestPermission: () -> Void
    @State private var buttonOpacity: Double = 0
    @State private var buttonRotation: Double = 0
    
    private let permissionHaiku = "Through mist and shadow\nYour presence calls to the void\nShare your location"
    
    var body: some View {
        VStack {
            AnimatedTextLines(text: permissionHaiku) {
                withAnimation(.easeIn(duration: 0.8)) {
                    buttonOpacity = 1
                }
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    buttonRotation = 360
                }
            }
            .multilineTextAlignment(.leading)
            .padding()
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            
            Button {
                onRequestPermission()
            } label: {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: "#d4d4d4"))
                    .rotationEffect(.degrees(buttonRotation))
                    .frame(width: 96, height: 96)
                    .background(Color(hex: "#191919"))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "#d4d4d4").opacity(0.3), lineWidth: 1)
                    )
            }
            .opacity(buttonOpacity)
            .padding(.bottom)
        }
    }
}

struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingDetails = false
    @State private var currentWeatherMessage: String = ""
    @State private var messageOpacity: Double = 0
    @State private var settingsButtonOpacity: Double = 0
    @State private var gearRotation: Double = 0
    
    // Add haptic feedback generator
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            // Animated noise background
            NoiseBackground()
                .ignoresSafeArea()
            
            // Main Content
            VStack {
                if locationManager.permissionStatus == .notDetermined {
                    LocationPermissionView {
                        locationManager.requestPermission()
                    }
                } else if let locationError = locationManager.error {
                    AnimatedTextLines(text: locationError.message) {
                        withAnimation(.easeIn(duration: 0.8)) {
                            settingsButtonOpacity = 1
                        }
                        // Start rotation animation after button appears
                        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                            gearRotation = 360
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onAppear {
                        // Reset button opacity and rotation when error appears
                        settingsButtonOpacity = 0
                        gearRotation = 0
                    }
                    .onChange(of: locationError.message) { _, _ in
                        // Reset button opacity and rotation when error message changes
                        settingsButtonOpacity = 0
                        gearRotation = 0
                    }
                    
                    Button {
                        locationManager.openSettings()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 36))
                            .foregroundColor(Color(hex: "#d4d4d4"))
                            .rotationEffect(.degrees(gearRotation))
                            .frame(width: 96, height: 96)
                            .background(Color(hex: "#191919"))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "#d4d4d4").opacity(0.3), lineWidth: 1)
                            )
                    }
                    .opacity(settingsButtonOpacity)
                    .padding(.bottom)
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
                        .onLongPressGesture(minimumDuration: 1.0, maximumDistance: .infinity, pressing: { isPressing in
                            withAnimation(
                                isPressing ?
                                    .easeInOut(duration: 0.4) :     // Smooth appearance
                                    .easeInOut(duration: 0.25)       // Faster disappearance
                            ) {
                                isShowingDetails = isPressing
                                // Trigger haptic feedback
                                impactGenerator.impactOccurred()
                            }
                        }, perform: { })
                } else {
                    Image(systemName: "eye")
                        .font(.system(size: 64))
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
