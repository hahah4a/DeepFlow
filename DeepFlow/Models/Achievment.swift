import Foundation

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    let color: String
    let requirement: Int // Sesiones requeridas
    let isUnlocked: Bool
    let unlockDate: Date?
    
    init(id: UUID = UUID(), title: String, description: String, iconName: String, color: String, requirement: Int, isUnlocked: Bool = false, unlockDate: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.color = color
        self.requirement = requirement
        self.isUnlocked = isUnlocked
        self.unlockDate = unlockDate
    }
}

