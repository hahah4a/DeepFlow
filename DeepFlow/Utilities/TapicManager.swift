import UIKit
import SwiftUI

class TapticManager: ObservableObject {
    static let shared = TapticManager()
    
    // Generadores para diferentes tipos de feedback
    private var notificationGenerator: UINotificationFeedbackGenerator?
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    private var selectionGenerator: UISelectionFeedbackGenerator?
    
    private var isPrepared = false
    
    private init() {
        prepareGenerators()
    }
    
    private func prepareGenerators() {
        // Preparar generadores en background para mejor rendimiento
        DispatchQueue.global(qos: .userInitiated).async {
            self.notificationGenerator = UINotificationFeedbackGenerator()
            self.notificationGenerator?.prepare()
            
            // Crear generadores para todos los estilos de impacto
            let styles: [UIImpactFeedbackGenerator.FeedbackStyle] = [.light, .medium, .heavy, .soft, .rigid]
            for style in styles {
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.prepare()
                self.impactGenerators[style] = generator
            }
            
            self.selectionGenerator = UISelectionFeedbackGenerator()
            self.selectionGenerator?.prepare()
            
            DispatchQueue.main.async {
                self.isPrepared = true
            }
        }
    }
    
    // MARK: - Public Methods
    
    /// Vibración de notificación (éxito, error, warning)
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isPrepared else { return }
        
        DispatchQueue.main.async {
            self.notificationGenerator?.notificationOccurred(type)
            // Re-preparar para el próximo uso
            self.notificationGenerator?.prepare()
        }
    }
    
    /// Vibración de impacto (toques físicos)
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard isPrepared else { return }
        
        DispatchQueue.main.async {
            if let generator = self.impactGenerators[style] {
                generator.impactOccurred()
                // Re-preparar para el próximo uso
                generator.prepare()
            } else {
                // Fallback a un generador nuevo si no existe
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.prepare()
                generator.impactOccurred()
                self.impactGenerators[style] = generator
            }
        }
    }
    
    /// Vibración de selección (cambios sutiles)
    func selection() {
        guard isPrepared else { return }
        
        DispatchQueue.main.async {
            self.selectionGenerator?.selectionChanged()
            // Re-preparar para el próximo uso
            self.selectionGenerator?.prepare()
        }
    }
    
    /// Vibración personalizada para acciones específicas de la app
    func customFeedback(for action: TapticAction) {
        switch action {
        case .sessionStart:
            notification(.success)
            
        case .sessionComplete:
            // Combinación de notificación e impacto
            notification(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.impact(.heavy)
            }
            
        case .sessionPause:
            impact(.medium)
            
        case .sessionCancel:
            notification(.error)
            
        case .buttonTap:
            impact(.light)
            
        case .minuteTick:
            selection()
            
        case .achievementUnlock:
            // Secuencia especial para logros
            impact(.heavy)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.impact(.medium)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.notification(.success)
            }
        }
    }
    
    /// Verificar si el dispositivo soporta Taptic Engine
    func supportsTaptic() -> Bool {
        let device = UIDevice.current
        
        // iPhones con Taptic Engine (iPhone 7 en adelante)
        if device.userInterfaceIdiom == .phone {
            let model = device.model
            return !model.contains("iPhone6") && !model.contains("iPhone5") && !model.contains("iPhoneSE1")
        }
        
        return false
    }
    
    /// Forzar preparación de generadores (útil cuando la app vuelve de background)
    func prepareForUse() {
        guard !isPrepared else { return }
        prepareGenerators()
    }
    
    // MARK: - Cleanup
    
    deinit {
        notificationGenerator = nil
        impactGenerators.removeAll()
        selectionGenerator = nil
    }
}

// MARK: - Taptic Actions Enum

enum TapticAction {
    case sessionStart
    case sessionComplete
    case sessionPause
    case sessionCancel
    case buttonTap
    case minuteTick
    case achievementUnlock
}

// MARK: - Extension para uso simplificado

extension TapticManager {
    /// Método simplificado para acciones comunes
    func gentleTap() {
        impact(.light)
    }
    
    func mediumTap() {
        impact(.medium)
    }
    
    func strongTap() {
        impact(.heavy)
    }
    
    func success() {
        notification(.success)
    }
    
    func warning() {
        notification(.warning)
    }
    
    func error() {
        notification(.error)
    }
}
