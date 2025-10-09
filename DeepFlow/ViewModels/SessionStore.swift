import Foundation
import SwiftUI

class SessionStore: ObservableObject {
    @Published var sessions: [Session] = []
    private let saveKey = "saved_sessions"
    
    init() {
        loadSessions()
    }
    
    func addSession(_ session: Session) {
        sessions.insert(session, at: 0) // Agregar al inicio
        saveSessions()
    }
    
    func getTodaysSessions() -> [Session] {
        return sessions.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    func getThisWeeksSessions() -> [Session] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return sessions.filter { $0.date >= oneWeekAgo }
    }
    
    // Métricas calculadas
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
    
    // Persistencia
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
}
