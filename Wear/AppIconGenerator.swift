import SwiftUI

struct AppIconGenerator: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "#191919"),
                    Color(hex: "#000000")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Noise effect
            NoiseBackground()
            
            // OmenIcon
            Image("ic_omen")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 512, height: 512)
                .foregroundColor(Color(hex: "#d4d4d4"))
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview {
    AppIconGenerator()
} 