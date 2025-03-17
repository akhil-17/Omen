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
    let location: CLLocation
    @State private var locationName: String = ""
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            NoiseBackground()
                .ignoresSafeArea()
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                
                // Location name with fixed height
                Text(locationName)
                    .font(.custom("Optima-Regular", size: 22))
                    .foregroundColor(Color(hex: "#d4d4d4").opacity(0.7))
                    .frame(height: 28) // Increased height to match new font size
                    .opacity(locationName.isEmpty ? 0 : 1)
                
                Text("\(Int(temperature))°F")
                    .font(.custom("Optima-Bold", size: 75))
                    .foregroundColor(Color(hex: "#d4d4d4"))
                
                if let humidity = humidity {
                    HStack(spacing: 0) {
                        Text("Humidity ")
                            .font(.custom("Optima-Regular", size: 35))
                        Text("\(humidity)%")
                            .font(.custom("Optima-Bold", size: 35))
                    }
                    .foregroundColor(Color(hex: "#d4d4d4"))
                }
                
                if let windSpeed = windSpeed {
                    HStack(spacing: 0) {
                        Text("Wind ")
                            .font(.custom("Optima-Regular", size: 35))
                        Text(String(format: "%.1f mph", windSpeed))
                            .font(.custom("Optima-Bold", size: 35))
                    }
                    .foregroundColor(Color(hex: "#d4d4d4"))
                }
                
                if let precipitation = precipitation {
                    HStack(spacing: 0) {
                        Text("Rain ")
                            .font(.custom("Optima-Regular", size: 35))
                        Text(String(format: "%.1f mm", precipitation))
                            .font(.custom("Optima-Bold", size: 35))
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
                
                // Attribution text
                Text("Weather data by Open-Meteo.com")
                    .font(.custom("Optima-Regular", size: 15))
                    .foregroundColor(Color(hex: "#d4d4d4").opacity(0.7))
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .opacity(contentOpacity)
        }
        .padding(.horizontal)
        .task {
            await getLocationName()
            withAnimation(.easeOut(duration: 0.4)) {
                contentOpacity = 1
            }
        }
        .onDisappear {
            contentOpacity = 0
        }
    }
    
    private func getLocationName() async {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                if let city = placemark.locality,
                   let state = placemark.administrativeArea,
                   placemark.isoCountryCode == "US" {
                    locationName = "\(city), \(state)"
                } else if let city = placemark.locality,
                          let country = placemark.country {
                    locationName = "\(city), \(country)"
                } else if let name = placemark.name {
                    locationName = name
                }
            }
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
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
        
        return VStack(alignment: .leading, spacing: 24) {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                Text(line)
                    .font(.custom("Optima-Regular", size: 48))
                    .foregroundColor(Color(hex: "#d4d4d4"))
                    .opacity(lineOpacities[safe: index] ?? 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: text) { oldValue, newValue in
            startAnimation(for: newValue)
        }
        .onAppear {
            startAnimation(for: text)
        }
    }
    
    private func startAnimation(for text: String) {
        let lines = text.components(separatedBy: .newlines)
        lineOpacities = Array(repeating: 0, count: lines.count)
        
        // Add initial delay of 0.5 second before starting animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Animate each line with a delay
            for (index, _) in lines.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) { // Reduced from 0.8 to 0.5
                    withAnimation(.easeIn(duration: 0.8)) { // Keep original animation duration
                        if index < lineOpacities.count {
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

struct OmenIcon: View {
    @State private var opacity: Double = 0
    
    var body: some View {
        Image("ic_omen")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 96, height: 96)
            .foregroundColor(Color(hex: "#d4d4d4"))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    opacity = 1
                }
            }
    }
}

struct SplashScreen: View {
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Use the same background as main app
            NoiseBackground()
                .ignoresSafeArea()
            
            OmenIcon()
                .frame(width: 200, height: 200)
                .opacity(opacity)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1
                scale = 1.0
            }
            
            // Trigger completion after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }
}

struct HaikuTransitionView: View {
    let onComplete: () -> Void
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        OmenIcon()
            .frame(width: 200, height: 200)
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    opacity = 1
                    scale = 1.0
                }
                
                // Trigger completion after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        opacity = 0
                        scale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onComplete()
                    }
                }
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
    @State private var showSplash = true
    @State private var isTransitioning = false
    private let sharedData = SharedWeatherData.shared
    private let weatherRefreshTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    // Add haptic feedback generator
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // Preview initializer
    init(previewWeatherService: WeatherService? = nil, previewLocationManager: LocationManager? = nil, initialMessage: String? = nil) {
        if let service = previewWeatherService {
            _weatherService = StateObject(wrappedValue: service)
        }
        if let manager = previewLocationManager {
            _locationManager = StateObject(wrappedValue: manager)
        }
        if let message = initialMessage {
            _currentWeatherMessage = State(initialValue: message)
            _messageOpacity = State(initialValue: 1)
            _showSplash = State(initialValue: false)
        }
    }
    
    private func refreshWeatherData() {
        if let location = locationManager.location {
            Task {
                await weatherService.fetchWeather(for: location)
            }
        }
    }
    
    private func updateHaikuMessage() {
        if weatherService.weatherCondition != nil {
            isTransitioning = true
            messageOpacity = 0
        }
    }
    
    private func completeHaikuTransition() {
        if let condition = weatherService.weatherCondition {
            currentWeatherMessage = WeatherMessages.randomMessage(for: condition)
            sharedData.currentHaiku = currentWeatherMessage
            print("New message: \(currentWeatherMessage)")
            isTransitioning = false
            withAnimation(.easeIn(duration: 0.5)) {
                messageOpacity = 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background that persists across transitions
            NoiseBackground()
                .ignoresSafeArea()
            
            if showSplash {
                SplashScreen {
                    withAnimation {
                        showSplash = false
                    }
                }
            } else {
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
                            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                                gearRotation = 360
                            }
                        }
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onAppear {
                            settingsButtonOpacity = 0
                            gearRotation = 0
                            sharedData.currentHaiku = locationError.message
                        }
                        .onChange(of: locationError.message) { _, newValue in
                            settingsButtonOpacity = 0
                            gearRotation = 0
                            sharedData.currentHaiku = newValue
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
                        AnimatedTextLines(text: error.message) {
                            withAnimation(.easeIn(duration: 0.8)) {
                                settingsButtonOpacity = 1
                            }
                            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                                gearRotation = 360
                            }
                        }
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onAppear {
                            settingsButtonOpacity = 0
                            gearRotation = 0
                            sharedData.currentHaiku = error.message
                        }
                        
                        if case .networkError = error {
                            Button {
                                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                    Task {
                                        await UIApplication.shared.open(settingsUrl)
                                    }
                                }
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
                        }
                    } else if let _ = weatherService.currentTemperature,
                              let _ = weatherService.weatherCondition,
                              let _ = locationManager.location {
                        ZStack {
                            VStack(spacing: 48) {
                                AnimatedTextLines(text: currentWeatherMessage)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                    .frame(maxHeight: .infinity)
                                    .contentShape(Rectangle())
                                    .opacity(messageOpacity)
                                    .animation(
                                        isShowingDetails ? 
                                            .easeOut(duration: 0.3) : // Fade out
                                            .easeIn(duration: 0.2),   // Faster fade in
                                        value: messageOpacity
                                    )
                            }
                            
                            if isTransitioning {
                                HaikuTransitionView {
                                    completeHaikuTransition()
                                }
                            }
                        }
                        .onLongPressGesture(minimumDuration: 1.0, maximumDistance: .infinity, pressing: { isPressing in
                            withAnimation(
                                isPressing ?
                                    .easeInOut(duration: 0.4) :     // Smooth appearance
                                    .easeInOut(duration: 0.25)       // Faster disappearance
                            ) {
                                isShowingDetails = isPressing
                                messageOpacity = isPressing ? 0 : 1  // Fade message with overlay
                                // Trigger haptic feedback
                                impactGenerator.impactOccurred()
                            }
                        }, perform: { })
                    } else {
                        OmenIcon()
                    }
                }
                .padding(.horizontal)
                
                // Overlay
                if isShowingDetails,
                   let temperature = weatherService.currentTemperature,
                   let condition = weatherService.weatherCondition,
                   let location = locationManager.location {
                    WeatherDetailsOverlay(
                        temperature: temperature,
                        condition: condition,
                        humidity: weatherService.humidity,
                        windSpeed: weatherService.windSpeed,
                        precipitation: weatherService.precipitation,
                        thunderstormProbability: weatherService.thunderstormProbability,
                        location: location
                    )
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.02)),
                            removal: .opacity.combined(with: .scale(scale: 1.02))
                        )
                    )
                }
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
                updateHaikuMessage()
            }
        }
        .onReceive(weatherRefreshTimer) { _ in
            refreshWeatherData()
            updateHaikuMessage()
        }
    }
}

struct WeatherDataView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.custom("Optima-Regular", size: 20))
                .foregroundColor(Color(hex: "#d4d4d4"))
            Text(label)
                .font(.custom("Optima-Regular", size: 15))
                .foregroundColor(Color(hex: "#d4d4d4").opacity(0.7))
        }
    }
}

#Preview {
    ContentView()
}

// Preview helpers
class PreviewWeatherService: WeatherService {
    override init() {
        super.init()
        self.currentTemperature = 75.0
        self.humidity = 85
        self.windSpeed = 15.5
        self.precipitation = 25.0
        self.thunderstormProbability = 75
    }
    
    override func fetchWeather(for location: CLLocation) async {
        return
    }
}

class PreviewLocationManager: LocationManager {
    override init() {
        super.init()
        self.location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        self.permissionStatus = .authorizedWhenInUse
    }
    
    override func requestLocation() {
        return
    }
}

// Split previews into categories
struct PrecipitationPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Thunderstorm
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 72.0
                    service.humidity = 85
                    service.windSpeed = 25.0
                    service.precipitation = 35.0
                    service.thunderstormProbability = 40
                    service.weatherCondition = .thunderstorm
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .thunderstorm)
            )
            .previewDisplayName("Thunderstorm")
            
            // Snowy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 28.0
                    service.humidity = 85
                    service.windSpeed = 12.0
                    service.precipitation = 15.0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .snowy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .snowy)
            )
            .previewDisplayName("Snowy")
            
            // Downpour
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 60.0
                    service.humidity = 95
                    service.windSpeed = 15.0
                    service.precipitation = 8.0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .downpour
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .downpour)
            )
            .previewDisplayName("Downpour")
            
            // Rainy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 62.0
                    service.humidity = 90
                    service.windSpeed = 12.0
                    service.precipitation = 5.0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .rainy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .rainy)
            )
            .previewDisplayName("Rainy")
            
            // Drizzle
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 65.0
                    service.humidity = 85
                    service.windSpeed = 7.0
                    service.precipitation = 1.0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .drizzle
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .drizzle)
            )
            .previewDisplayName("Drizzle")
        }
    }
}

struct WindAndCloudPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Stormy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 68.0
                    service.humidity = 80
                    service.windSpeed = 45.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .stormy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .stormy)
            )
            .previewDisplayName("Stormy")
            
            // Windy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 65.0
                    service.humidity = 50
                    service.windSpeed = 25.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .windy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .windy)
            )
            .previewDisplayName("Windy")
            
            // Foggy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 55.0
                    service.humidity = 95
                    service.windSpeed = 3.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .foggy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .foggy)
            )
            .previewDisplayName("Foggy")
            
            // Cloudy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 70.0
                    service.humidity = 85
                    service.windSpeed = 10.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .cloudy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .cloudy)
            )
            .previewDisplayName("Cloudy")
            
            // Partly Cloudy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 75.0
                    service.humidity = 70
                    service.windSpeed = 8.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .partlyCloudy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .partlyCloudy)
            )
            .previewDisplayName("Partly Cloudy")
        }
    }
}

struct HotWeatherPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Hellscape
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 102.0
                    service.humidity = 30
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .hellscape
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .hellscape)
            )
            .previewDisplayName("Hellscape")
            
            // Inferno
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 95.0
                    service.humidity = 35
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .inferno
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .inferno)
            )
            .previewDisplayName("Inferno")
            
            // Sweltering
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 85.0
                    service.humidity = 40
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .sweltering
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .sweltering)
            )
            .previewDisplayName("Sweltering")
            
            // Sultry
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 75.0
                    service.humidity = 45
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .sultry
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .sultry)
            )
            .previewDisplayName("Sultry")
            
            // Balmy
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 65.0
                    service.humidity = 50
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .balmy
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .balmy)
            )
            .previewDisplayName("Balmy")
        }
    }
}

struct MildWeatherPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Temperate
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 55.0
                    service.humidity = 55
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .temperate
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .temperate)
            )
            .previewDisplayName("Temperate")
            
            // Brisk
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 45.0
                    service.humidity = 60
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .brisk
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .brisk)
            )
            .previewDisplayName("Brisk")
            
            // Chilly
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 35.0
                    service.humidity = 65
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .chilly
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .chilly)
            )
            .previewDisplayName("Chilly")
        }
    }
}

struct ColdWeatherPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Frosty
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 25.0
                    service.humidity = 70
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .frosty
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .frosty)
            )
            .previewDisplayName("Frosty")
            
            // Frigid
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 15.0
                    service.humidity = 75
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .frigid
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .frigid)
            )
            .previewDisplayName("Frigid")
            
            // Glacial
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = 5.0
                    service.humidity = 80
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .glacial
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .glacial)
            )
            .previewDisplayName("Glacial")
            
            // Polar
            ContentView(
                previewWeatherService: {
                    let service = PreviewWeatherService()
                    service.currentTemperature = -5.0
                    service.humidity = 85
                    service.windSpeed = 5.0
                    service.precipitation = 0
                    service.thunderstormProbability = 0
                    service.weatherCondition = .polar
                    return service
                }(),
                previewLocationManager: PreviewLocationManager(),
                initialMessage: WeatherMessages.randomMessage(for: .polar)
            )
            .previewDisplayName("Polar")
        }
    }
}
