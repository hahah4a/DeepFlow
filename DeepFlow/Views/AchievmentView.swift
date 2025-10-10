import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .frame(width: 400, height: 0)
                    .foregroundStyle(Color.black.opacity(0.95))
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Logros")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("\(sessionStore.achievements.filter { $0.isUnlocked }.count)/\(sessionStore.achievements.count) desbloqueados")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(sessionStore.achievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            sessionStore.checkAchievements()
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var color: Color {
        switch achievement.color {
        case "blue": return .blue
        case "orange": return .orange
        case "yellow": return .yellow
        case "purple": return .purple
        case "red": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.iconName)
                .font(.title)
                .foregroundColor(achievement.isUnlocked ? color : .gray)
                .opacity(achievement.isUnlocked ? 1.0 : 0.3)
            
            VStack(spacing: 6) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                if !achievement.isUnlocked {
                    Text("\(achievement.requirement) sesiones")
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.top, 4)
                } else if let unlockDate = achievement.unlockDate {
                    Text("Desbloqueado: \(formatDate(unlockDate))")
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                }
            }
        }
        .padding()
        .frame(width: 180, height: 140)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(achievement.isUnlocked ? color : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(SessionStore())
}
