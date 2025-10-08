import SwiftUI

struct SummaryView: View {
    @State private var selectedTimeFrame = 0
    let timeFrames = ["Hoy", "Semana", "Mes", "Total"]
    
    // Datos de ejemplo - luego conectaremos con datos reales
    let sessionStats = [
        ("Sesiones Completadas", "12", "checkmark.circle.fill", Color.green),
        ("Tiempo Total", "8h 30m", "clock.fill", Color.blue),
        ("Tiempo en Flow", "6h 15m", "brain.head.profile", Color.purple),
        ("Focus Promedio", "74%", "chart.line.uptrend.xyaxis", Color.orange)
    ]
    
    let recentSessions = [
        ("Diseño UI", "2h", "Hoy - 14:30", true),
        ("Reunión Planificación", "1h", "Hoy - 10:15", false),
        ("Desarrollo Features", "3h", "Ayer - 15:45", true),
        ("Revision Código", "45m", "Ayer - 11:20", true)
    ]
    
    var body: some View {
        ZStack {
            // Fondo negro con opacidad
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .frame(width: 400,height: 0)
                    .foregroundStyle(Color.blue)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Resumen")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Tu progreso de productividad")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // Selector de período
                        HStack(spacing: 0) {
                            ForEach(0..<timeFrames.count, id: \.self) { index in
                                Button(action: {
                                    selectedTimeFrame = index
                                }) {
                                    Text(timeFrames[index])
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(selectedTimeFrame == index ? .black : .white)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .background(selectedTimeFrame == index ? Color.white : Color.clear)
                                        .animation(.smooth, value: selectedTimeFrame)
                                }
                            }
                        }
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        // Estadísticas principales
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(sessionStats, id: \.0) { stat in
                                StatCard(
                                    title: stat.0,
                                    value: stat.1,
                                    icon: stat.2,
                                    color: stat.3
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sesiones recientes
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Sesiones Recientes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("Ver todo")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(recentSessions, id: \.0) { session in
                                    SessionRow(
                                        title: session.0,
                                        duration: session.1,
                                        date: session.2,
                                        completed: session.3
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Insights
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Insights")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                InsightCard(
                                    icon: "sparkles",
                                    title: "Mejor horario",
                                    description: "Eres más productivo entre 14:00 - 17:00",
                                    color: .yellow
                                )
                                
                                InsightCard(
                                    icon: "flag",
                                    title: "Récord personal",
                                    description: "4 sesiones completadas en un día",
                                    color: .green
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// Componente para tarjetas de estadísticas
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// Componente para filas de sesión
struct SessionRow: View {
    let title: String
    let duration: String
    let date: String
    let completed: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: completed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(completed ? .green : .red)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(duration)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// Componente para insights
struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        SummaryView()
    }
}

