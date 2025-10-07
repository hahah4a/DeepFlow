import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 1500 // 25 minutos en segundos
    @State private var timerIsRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.95)
            VStack {
                // Timer circular
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .opacity(0.3)
                        .foregroundColor(.white)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(timeRemaining) / 1500.0)
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 270.0))
                    
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                }
                .frame(width: 200, height: 200)
                .padding()
                
                // Botones de control
                HStack {
                    Button(timerIsRunning ? "Pausar" : "Comenzar") {
                        timerIsRunning.toggle()
                    }
                    .frame(width: 100, height: 25)
                    .background(Color.white)
                    .foregroundStyle(Color.black)
                    .cornerRadius(20)
                    
                    Button("Reiniciar") {
                        timeRemaining = 1500
                        timerIsRunning = false
                    }
                    .frame(width: 100, height: 25)
                    .background(Color.white)
                    .foregroundStyle(Color.black)
                    .cornerRadius(20)
                }
            }
            .onReceive(timer) { _ in
                if timerIsRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

