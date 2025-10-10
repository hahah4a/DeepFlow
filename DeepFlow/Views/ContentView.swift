import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    @StateObject private var sessionStore = SessionStore()
    
    var body: some View {
        ZStack {
            // Fondo negro consistente
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            
            // TabView personalizado
            TabView(selection: $selectedTab) {
                // Pestaña 1: Configuración
                ConfigView()
                    .tabItem {
                        VStack {
                            Image(systemName: selectedTab == 0 ? "gear.circle.fill" : "gear")
                                .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                            Text("Configurar")
                        }
                    }
                    .tag(0)
                
                // Pestaña 2: Focus
                FocusView()
                    .tabItem {
                        VStack {
                            Image(systemName: selectedTab == 1 ? "timer.circle.fill" : "timer")
                                .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                            Text("Focus")
                        }
                    }
                    .tag(1)
                
                // Pestaña 3: Resumen
                SummaryView()
                    .tabItem {
                        VStack {
                            Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                                .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                            Text("Resumen")
                        }
                    }
                    .tag(2)
                
                AchievementsView()
                        .tabItem {
                            VStack {
                                Image(systemName: selectedTab == 3 ? "medal.fill" : "medal")
                                    .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                                Text("Logros")
                            }
                        }
                        .tag(3)
            }
            .accentColor(.white) // Color del tab seleccionado
            .onAppear {
                // Personalizar la apariencia del TabView para iOS 15+
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.black.withAlphaComponent(0.95)
                
                // Estilo para los items no seleccionados
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
                
                // Estilo para los items seleccionados
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                // Aplicar la apariencia
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .environmentObject(sessionStore)
        }
    }
}

#Preview {
    ContentView()
}
