import SwiftUI

struct PreparationView: View {
    @AppStorage("workDurationMinutes") private var workDurationMinutes = 60
    @State private var sessionObjective = ""
    @State private var isActive = false
    
    func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            return "\(hours) \(hours == 1 ? "hora" : "horas")"
        }
    }
    
    var isFormValid: Bool {
        !sessionObjective.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            // Fondo negro con opacidad
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            // Contenido centrado
            VStack(spacing: 50) {
                // Título
                VStack(spacing: 8) {
                    Text("Preparación")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Define tu objetivo")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                Spacer()
        
                // Campo de texto para el objetivo
                VStack(alignment: .leading, spacing: 15) {
                    Text("¿Qué quieres lograr en esta sesión?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextEditor(text: $sessionObjective)
                        .frame(height: 120)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .scrollContentBackground(.hidden) // Oculta el fondo por defecto
                    
                    if !isFormValid {
                        Text("Escribe tu objetivo para continuar")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                

                // Información adicional
                VStack(spacing: 8) {
                    Image(systemName: "lightbulb")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    
                    Text("Un objetivo claro aumenta tu enfoque")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Botón de comenzar
                Button(action: {
                    isActive = true
                }) {
                    HStack {
                        Text("Comenzar Sesión")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "play.circle.fill")
                    }
                    .foregroundColor(isFormValid ? .black : .gray)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(16)
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                
                // Enlace de navegación (oculto)
                NavigationLink(
                    destination: FocusView(sessionObjective: sessionObjective),
                    isActive: $isActive
                ) { EmptyView() }
            }
            .padding(.bottom, 40)
            .offset(y:10)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationView {
        PreparationView()
    }
}

