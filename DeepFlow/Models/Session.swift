import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    let objective: String
    let duration: Int // en minutos
    let actualDuration: Int // en segundos - tiempo realmente enfocado
    let date: Date
    let completed: Bool
    
    init(id: UUID = UUID(), objective: String, duration: Int, actualDuration: Int, date: Date = Date(), completed: Bool = true) {
        self.id = id
        self.objective = objective
        self.duration = duration
        self.actualDuration = actualDuration
        self.date = date
        self.completed = completed
    }
    
    // Formatear fecha para mostrar
    func formattedDate() -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Hoy - \(formatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Ayer - \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "dd/MM - HH:mm"
            return formatter.string(from: date)
        }
    }
    
    // Calcular porcentaje de focus
    func focusPercentage() -> Int {
        let plannedSeconds = duration * 60
        guard plannedSeconds > 0 else { return 0 }
        return Int(Double(actualDuration) / Double(plannedSeconds) * 100)
    }
}

