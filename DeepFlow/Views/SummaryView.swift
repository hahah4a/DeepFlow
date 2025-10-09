import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var selectedTimeFrame = 0
    let timeFrames = ["Hoy", "Semana", "Mes", "Total"]
    
    // Datos reales del SessionStore
    var displayedSessions: [Session] {
        switch selectedTimeFrame {
        case 0: return sessionStore.getTodaysSessions()
        case 1: return sessionStore.getThisWeeksSessions()
        case 2: return sessionStore.sessions.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }
        default: return sessionStore.sessions
        }
    }
    
    var sessionStats: [(String, String, String, Color)] {
        let totalTime = sessionStore.totalFocusTime()
        let hours = totalTime / 3600
        let minutes = (totalTime % 3600) / 60
        
        return [
            ("Sesiones Completadas", "\(sessionStore.totalSessions())", "checkmark.circle.fill", Color.green),
            ("Tiempo Total", "\(hours)h \(minutes)m", "clock.fill", Color.blue),
            ("Focus Promedio", "\(sessionStore.averageFocusPercentage())%", "chart.line.uptrend.xyaxis", Color.orange),
            ("Sesiones Hoy", "\(sessionStore.getTodaysSessions().count)", "flame.fill", Color.purple)
        ]
    }
    
    // Insights basados en datos reales
    var insights: [(String, String, String, Color)] {
        var insightsList: [(String, String, String, Color)] = []
        
        let todaysSessions = sessionStore.getTodaysSessions()
        if todaysSessions.count >= 3 {
            insightsList.append((
                "sparkles",
                "Día productivo",
                "Has completado \(todaysSessions.count) sesiones hoy",
                .yellow
            ))
        }
        
        if sessionStore.averageFocusPercentage() > 80 {
            insightsList.append((
                "brain.head.profile",
                "Alto enfoque",
                "Tu focus promedio es excelente",
                .green
            ))
        }
        
        if sessionStore.totalSessions() > 10 {
            insightsList.append((
                "flag",
                "Muy constante",
                "Llevas \(sessionStore.totalSessions()) sesiones",
                .blue
            ))
        }
        
        // Insight por defecto si no hay datos
        if insightsList.isEmpty {
            insightsList.append((
                "lightbulb",
                "Comienza tu journey",
                "Completa tu primera sesión para ver insights",
                .gray
            ))
        }
        
        return insightsList
    }
    
    var body: some View {
        ZStack {
            // Fondo negro con opacidad
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .frame(width: 400, height: 0)
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
                        
                        // Estadísticas principales con datos reales
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
                        
                        // Sesiones recientes con datos reales
                        if !displayedSessions.isEmpty {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Sesiones Recientes")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(displayedSessions.count) sesiones")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    ForEach(displayedSessions.prefix(6)) { session in
                                        SessionRow(
                                            title: session.objective,
                                            duration: "\(session.duration) min",
                                            date: session.formattedDate(),
                                            completed: session.completed,
                                            focusPercentage: session.focusPercentage()
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            // Mensaje cuando no hay sesiones
                            VStack(spacing: 20) {
                                Image(systemName: "clock.badge.questionmark")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                Text("No hay sesiones registradas")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Completa tu primera sesión de focus para ver estadísticas")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Insights con datos reales
                        if !insights.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Insights")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    ForEach(insights.prefix(2), id: \.0) { insight in
                                        InsightCard(
                                            icon: insight.0,
                                            title: insight.1,
                                            description: insight.2,
                                            color: insight.3
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Recargar datos cuando aparece la vista
            print("Sesiones totales: \(sessionStore.sessions.count)")
        }
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

// Componente para filas de sesión - ACTUALIZADO
struct SessionRow: View {
    let title: String
    let duration: String
    let date: String
    let completed: Bool
    let focusPercentage: Int
    
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
                    .lineLimit(1)
                
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(duration)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("\(focusPercentage)%")
                    .font(.caption)
                    .foregroundColor(focusPercentage >= 80 ? .green : .orange)
            }
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
            .environmentObject(SessionStore())
    }
}
