import SwiftUI

struct FocusView: View {
    @AppStorage("workDurationMinutes") private var workDurationMinutes = 60
    @EnvironmentObject var sessionStore : SessionStore
    var sessionObjective : String = ""
    
    @State private var timeRemaining = 0
    @State private var timerIsRunning = false
    @State private var showSummary = false
    @State private var sessionsCompleted = 0
    @State private var startTime: Date? = nil
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Computed property para verificar si la duración es válida
    var isDurationValid: Bool {
        workDurationMinutes > 0
    }
    
    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        }
    }
    
    func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            return "\(hours) \(hours == 1 ? "hora" : "horas")"
        }
    }
    
    var progress: Double {
        let totalSeconds = workDurationMinutes * 60
        return totalSeconds > 0 ? Double(timeRemaining) / Double(totalSeconds) : 0
    }
    
    var body: some View {
        ZStack {
            // Fondo negro con opacidad
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            // Contenido centrado
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 8) {
                    Text("Sesión de Focus")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Mantén tu concentración")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                // Timer circular
                if timerIsRunning || timeRemaining > 0 {
                    ZStack {
                        // Fondo del círculo
                        Circle()
                            .stroke(lineWidth: 8)
                            .opacity(0.3)
                            .foregroundColor(.white)
                        
                        // Progreso
                        Circle()
                            .trim(from: 0.0, to: CGFloat(1 - progress))
                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        
                        // Tiempo
                        VStack(spacing: 8) {
                            Text(formatTime(timeRemaining))
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Tiempo restante")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 280, height: 280)
                    
                    // Controles
                    HStack(spacing: 20) {
                        Button(action: {
                            timerIsRunning.toggle()
                        }) {
                            HStack {
                                Image(systemName: timerIsRunning ? "pause.circle.fill" : "play.circle.fill")
                                Text(timerIsRunning ? "Pausar" : "Reanudar")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 140)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            withAnimation{
                                timerIsRunning = false
                                timeRemaining = 0
                            }
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                Text("Cancelar")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 140)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(12)
                        }
                    }
                } else {
                    // Vista inicial - Antes de comenzar
                    VStack(spacing: 30) {
                        // Información de la sesión
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                Text("DURACIÓN PROGRAMADA")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .tracking(1.5)
                                
                                Text(formatDuration(workDurationMinutes))
                                    .font(.system(size: 42, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                        
                        // Mensaje de advertencia si la duración es 0
                        if !isDurationValid {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                Text("La duración no puede ser 0")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .multilineTextAlignment(.center)
                                
                                Text("Ve a Configuración para ajustar la duración")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // Consejo de productividad
                if !timerIsRunning {
                    VStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Text("Desactiva notificaciones para un focus completo")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                if !timerIsRunning && timeRemaining == 0 {
                    // Botón de comenzar - DESHABILITADO si la duración es 0
                    Button(action: {
                        withAnimation{
                            startSession()
                        }
                    }) {
                        HStack {
                            Text("Iniciar Sesión")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "play.circle.fill")
                        }
                        .foregroundColor(isDurationValid ? .black : .gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isDurationValid ? Color.white : Color.gray.opacity(0.3))
                        .cornerRadius(16)
                    }
                    .disabled(!isDurationValid) // ← DESHABILITAR si duración es 0
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 40)
        }
        .navigationBarHidden(true)
        .onReceive(timer) { _ in
            if timerIsRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    timerIsRunning = false
                    sessionsCompleted += 1
                    saveSession()
                    showSummary = true
                }
            }
        }
        .sheet(isPresented: $showSummary) {
            SummaryView()
        }
    }
    
    // Función para guardar una session
    private func saveSession() {
        let actualDuration = workDurationMinutes * 60 - timeRemaining
        let session = Session(
            objective: sessionObjective.isEmpty ? "Sesión de focus" : sessionObjective,
            duration: workDurationMinutes,
            actualDuration: actualDuration,
            date: startTime ?? Date(),
            completed: true
        )
        sessionStore.addSession(session)
    }
    
    private func startSession() {
        timeRemaining = workDurationMinutes * 60
        timerIsRunning = true
        startTime = Date() // ← Guardar hora de inicio
    }
}

#Preview {
    NavigationView {
        FocusView()
    }
}
