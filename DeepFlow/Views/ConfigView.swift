import SwiftUI

struct ConfigView: View {
    @AppStorage("workDurationMinutes") private var workDurationMinutes = 60
    @AppStorage("enableSounds") private var enableSounds = true
    
    let durationOptions = [30, 60, 120, 180, 240]
    
    func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            return "\(hours)h"
        }
    }
    
    var body: some View {
        ZStack {
            // Fondo negro con opacidad
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            // Contenido centrado
            VStack(spacing: 80) {
                // Título
                VStack(spacing: 8) {
                    Text("DeepFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Prepara tu sesión")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 20) {
                    Text("Selecciona la duración")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Picker personalizado para mejor control de colores
                    HStack(spacing: 0) {
                        ForEach(durationOptions, id: \.self) { minutes in
                            Button(action: {
                                workDurationMinutes = minutes
                            }) {
                                Text(formatDuration(minutes))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(workDurationMinutes == minutes ? .black : .white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(workDurationMinutes == minutes ? Color.white : Color.clear)
                            }
                        }
                    }
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // Toggle de sonidos
                HStack {
                    Image(systemName: "speaker.wave.2")
                        .foregroundColor(.white)
                    
                    Toggle("Sonidos ambientales", isOn: $enableSounds)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationView {
        ConfigView()
    }
}
