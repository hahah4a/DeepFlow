import Foundation
import WidgetKit
import SwiftUI

class SessionStore: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var achievements: [Achievement] = []
    
    private let saveKey = "saved_sessions"
    private let achievementsKey = "saved_achievements"
    
    init() {
        loadSessions()
        loadAchievements()
    }
    
    // MARK: - Gestión de Sesiones
    func addSession(_ session: Session) {
        sessions.insert(session, at: 0) // Agregar al inicio
        saveSessions()
        checkAchievements()// Verificar logros después de agregar sesión
        updateWidgetData()
    }
    
    func getTodaysSessions() -> [Session] {
        return sessions.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    func getThisWeeksSessions() -> [Session] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return sessions.filter { $0.date >= oneWeekAgo }
    }
    
    // MARK: - Métricas Calculadas
    func totalSessions() -> Int {
        return sessions.count
    }
    
    func totalFocusTime() -> Int {
        return sessions.reduce(0) { $0 + $1.actualDuration }
    }
    
    func averageFocusPercentage() -> Int {
        guard !sessions.isEmpty else { return 0 }
        let totalPercentage = sessions.reduce(0) { $0 + $1.focusPercentage() }
        return totalPercentage / sessions.count
    }
    
    // MARK: - Sistema de Logros
    func checkAchievements() {
        let totalSessions = sessions.count
        let todaysSessions = getTodaysSessions().count
        let totalFocusHours = totalFocusTime() / 3600
        
        var updatedAchievements = [
            Achievement(
                title: "Primeros Pasos",
                description: "Completa tu primera sesión",
                iconName: "flag.fill",
                color: "blue",
                requirement: 1,
                isUnlocked: totalSessions >= 1
            ),
            Achievement(
                title: "Consistente",
                description: "Completa 5 sesiones",
                iconName: "flame.fill",
                color: "orange",
                requirement: 5,
                isUnlocked: totalSessions >= 5
            ),
            Achievement(
                title: "Productivo",
                description: "Completa 10 sesiones",
                iconName: "bolt.fill",
                color: "yellow",
                requirement: 10,
                isUnlocked: totalSessions >= 10
            ),
            Achievement(
                title: "Maestro del Flow",
                description: "Completa 25 sesiones",
                iconName: "brain.head.profile",
                color: "purple",
                requirement: 25,
                isUnlocked: totalSessions >= 25
            ),
            Achievement(
                title: "Día Productivo",
                description: "Completa 3 sesiones en un día",
                iconName: "sun.max.fill",
                color: "red",
                requirement: 3,
                isUnlocked: todaysSessions >= 3
            ),
            Achievement(
                title: "Maratoniano",
                description: "Completa 50 sesiones",
                iconName: "infinity",
                color: "green",
                requirement: 50,
                isUnlocked: totalSessions >= 50
            ),
            Achievement(
                title: "Focus Total",
                description: "10 horas totales de focus",
                iconName: "clock.fill",
                color: "indigo",
                requirement: 10,
                isUnlocked: totalFocusHours >= 10
            )
        ]
        
        // Actualizar fechas de desbloqueo para logros nuevos
        for i in 0..<updatedAchievements.count {
            if updatedAchievements[i].isUnlocked {
                let existingAchievement = achievements.first { $0.title == updatedAchievements[i].title }
                
                if existingAchievement == nil {
                    // Es un logro nuevo desbloqueado
                    updatedAchievements[i] = Achievement(
                        title: updatedAchievements[i].title,
                        description: updatedAchievements[i].description,
                        iconName: updatedAchievements[i].iconName,
                        color: updatedAchievements[i].color,
                        requirement: updatedAchievements[i].requirement,
                        isUnlocked: true,
                        unlockDate: Date()
                    )
                } else if let existing = existingAchievement, existing.isUnlocked {
                    // Mantener la fecha de desbloqueo original
                    updatedAchievements[i] = existing
                }
            }
        }
        
        achievements = updatedAchievements
        saveAchievements()
    }
    
    func getUnlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.isUnlocked }
    }
    
    func getLockedAchievements() -> [Achievement] {
        return achievements.filter { !$0.isUnlocked }
    }
    
    // MARK: - Persistencia
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Session].self, from: data) {
            sessions = decoded
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            // Crear logros iniciales si no existen
            checkAchievements()
        }
    }
    
    // MARK: - Utilidades
    func clearAllData() {
        sessions.removeAll()
        achievements.removeAll()
        saveSessions()
        saveAchievements()
    }
    
    func exportSessions() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(sessions),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
    func updateWidgetData() {
        // Usar App Group para compartir datos
        if let sharedDefaults = UserDefaults(suiteName: "group.com.yourapp.deepflow") {
            sharedDefaults.set(totalSessions(), forKey: "sessions_completed")
            
            let totalTime = totalFocusTime()
            let hours = totalTime / 3600
            let minutes = (totalTime % 3600) / 60
            let focusTimeString = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
            sharedDefaults.set(focusTimeString, forKey: "focus_time")
            
            sharedDefaults.synchronize()
        }
        
        // Notificar al widget que se actualice
        WidgetCenter.shared.reloadAllTimelines()
    }
}
