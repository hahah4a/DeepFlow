import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var systemSoundID: SystemSoundID = 0
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    func playSound(_ soundName: String) {
        // Mapeo de sonidos del sistema
        let systemSounds: [String: SystemSoundID] = [
            "session_start": 1103,    // Tri-tone - sonido de inicio
            "session_complete": 1032, // Glass - sonido de completado
            "session_pause": 1105,    // Tock - sonido de pausa/cancelar
            "button_click": 1104      // Tap - sonido de botón
        ]
        
        // Detener sonido anterior si está reproduciéndose
        stopSound()
        
        if let soundID = systemSounds[soundName] {
            // Usar sonido del sistema
            AudioServicesPlaySystemSound(soundID)
        } else {
            // Intentar cargar sonido personalizado si existe
            playCustomSound(soundName)
        }
    }
    
    private func playCustomSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file \(soundName).mp3 not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func stopAllSounds() {
        stopSound()
        // Los System Sounds no se pueden detener una vez iniciados
    }
    
    func setVolume(_ volume: Float) {
        audioPlayer?.volume = volume
    }
    
    // Método para pre-cargar sonidos (útil para sonidos personalizados)
    func preloadSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch {
            print("Error preloading sound: \(error.localizedDescription)")
        }
    }
    
    // Verificar disponibilidad de sonidos
    func isSoundAvailable(_ soundName: String) -> Bool {
        let systemSounds: [String: SystemSoundID] = [
            "session_start": 1103,
            "session_complete": 1032,
            "session_pause": 1105,
            "button_click": 1104
        ]
        
        if systemSounds[soundName] != nil {
            return true
        }
        
        return Bundle.main.url(forResource: soundName, withExtension: "mp3") != nil
    }
    
    deinit {
        stopAllSounds()
    }
}
