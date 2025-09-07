//
//  ContentView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI
import SpriteKit

// Расширение для уведомлений
extension Notification.Name {
    static let restartGame = Notification.Name("restartGame")
}

struct SKViewRepresentable: UIViewRepresentable {
    var scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        // Важно: не презентовать сцену здесь, если мы управляем ею извне
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Презентуем сцену в updateUIView, чтобы гарантировать, что она всегда актуальна
        if uiView.scene != scene {
            uiView.presentScene(scene)
        }
    }
}

struct ContentView: View {
    @StateObject private var gameScene = GameScene(size: .zero)
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GameSceneView(scene: gameScene)
                GameUIView(gameScene: gameScene)
                
                // Экран проигрыша поверх всего
                if gameScene.isGameOver {
                    GameOverView(
                        finalScore: gameScene.score,
                        sessionCoins: gameScene.sessionCoins,
                        isNewRecord: gameScene.isNewRecord,
                        onHome: {
                            print("🔴 КРАСНАЯ КНОПКА HOME нажата - возвращаемся в главное меню")
                            // Закрываем игру и возвращаемся в главное меню
                            presentationMode.wrappedValue.dismiss()
                        },
                        onAgain: {
                            print("🔵 СИНЯЯ КНОПКА AGAIN нажата - отправляем уведомление о перезапуске")
                            // Отправляем уведомление о перезапуске игры
                            NotificationCenter.default.post(name: .restartGame, object: nil)
                            // Закрываем игру
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
            .onAppear {
                // Устанавливаем размер сцены, если он еще не установлен
                if gameScene.size == .zero {
                    gameScene.updateSize(newSize: geometry.size)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Отдельное представление для игровой сцены
struct GameSceneView: View {
    @ObservedObject var scene: GameScene
    
    var body: some View {
        SKViewRepresentable(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
