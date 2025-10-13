import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Sesiones para mostrar en el preview
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), sessionsCompleted: 12, focusTime: "8h 30m")
    }

    // Datos para el snapshot (vista previa)
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let sessions = UserDefaults(suiteName: "group.com.yourapp.deepflow")?.integer(forKey: "sessions_completed") ?? 0
        let focusTime = "\(sessions * 25)min" // Ejemplo calculado
        let entry = SimpleEntry(date: Date(), sessionsCompleted: sessions, focusTime: focusTime)
        completion(entry)
    }

    // Timeline con datos reales
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sessions = UserDefaults(suiteName: "group.com.yourapp.deepflow")?.integer(forKey: "sessions_completed") ?? 0
        let focusTime = "\(sessions * 25)min"
        let entry = SimpleEntry(date: Date(), sessionsCompleted: sessions, focusTime: focusTime)
        
        // Actualizar cada 6 horas o cuando la app notifique cambios
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let sessionsCompleted: Int
    let focusTime: String
}

struct DeepFlowWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// Widget pequeño
struct SmallWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.95)
            
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(spacing: 2) {
                    Text("\(entry.sessionsCompleted)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Sesiones")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Text(entry.focusTime)
                    .font(.caption2)
                    .foregroundColor(.green)
            }
            .padding()
        }
    }
}

// Widget mediano
struct MediumWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.95)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text("DeepFlow")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    StatRow(icon: "checkmark.circle", value: "\(entry.sessionsCompleted)", label: "Sesiones", color: .green)
                    StatRow(icon: "clock", value: entry.focusTime, label: "Focus", color: .blue)
                    StatRow(icon: "flame", value: "\(entry.sessionsCompleted * 25)", label: "Minutos", color: .orange)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct StatRow: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
                .frame(width: 12)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct DeepFlowWidget: Widget {
    let kind: String = "DeepFlowWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeepFlowWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DeepFlow Focus")
        .description("Mira tu progreso de sesiones de focus y tiempo productivo.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
