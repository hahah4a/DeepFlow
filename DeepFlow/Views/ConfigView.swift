import SwiftUI

struct ConfigView: View {
    @AppStorage("workDurationMinutes") private var workDurationMinutes = 60
    @AppStorage("enableSounds") private var enableSounds = true
    @State private var selectedHours = 1
    @State private var selectedMinutes = 0
    
    let hoursRange = Array(0...8)    // 0 a 8 horas
    let minutesRange = Array(0...59) // 0 a 59 minutos
    
    var totalMinutes: Int {
        (selectedHours * 60) + selectedMinutes
    }
    
    var formattedDuration: String {
        if totalMinutes == 0 {
            return "0 min"
        } else if totalMinutes < 60 {
            return "\(totalMinutes) min"
        } else {
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            
            if minutes == 0 {
                return "\(hours) \(hours == 1 ? "hora" : "horas")"
            } else {
                return "\(hours)h \(minutes)m"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Fondo negro con opacidad
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            // Contenido centrado
            VStack(spacing: 40) {
                // Título
                VStack(spacing: 8) {
                    Text("DeepFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Configura tu sesión")
                        .font(.title3)
                        .foregroundColor(.gray)
                }

                // Selector de tiempo estilo Apple
                VStack(spacing: 30) {
                    Text("Duración de la sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        // Selector de horas
                        VStack {
                            Picker("Horas", selection: $selectedHours) {
                                ForEach(hoursRange, id: \.self) { hour in
                                    Text("\(hour)")
                                        .font(.system(size: 22, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                        .tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 120, height: 150)
                            
                            Text("horas")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Separador
                        Text(":")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                        
                        // Selector de minutos
                        VStack {
                            Picker("Minutos", selection: $selectedMinutes) {
                                ForEach(minutesRange, id: \.self) { minute in
                                    Text("\(minute)")
                                        .font(.system(size: 22, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                        .tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 120, height: 150)
                            
                            Text("min")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Duración en texto formateado
                    Text(formattedDuration)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
                
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
                .padding(.horizontal)
                
                Spacer()
                
            }
            .padding(.vertical, 40)
        }
        .navigationBarHidden(true)
        .onAppear {
            // Convertir workDurationMinutes actual a horas y minutos
            selectedHours = workDurationMinutes / 60
            selectedMinutes = workDurationMinutes % 60
        }
        .onChange(of: totalMinutes) { newValue in
            // Actualizar workDurationMinutes cuando cambia la selección
            workDurationMinutes = newValue
        }
    }
}

#Preview {
    ZStack {
        ConfigView()
    }
}
