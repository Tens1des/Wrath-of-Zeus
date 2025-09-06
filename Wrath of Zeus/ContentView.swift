//
//  ContentView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI
import SpriteKit

struct SKViewRepresentable: UIViewRepresentable {
    var scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        view.presentScene(scene)
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Обновления, если необходимо
    }
}

struct ContentView: View {
    @State private var gameScene: GameScene?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Игровая сцена (фон теперь в GameScene)
                if let scene = gameScene {
                    GameSceneView(scene: scene)
                } else {
                    // Показываем загрузочный индикатор, пока сцена не готова
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                }
                
                // Игровой интерфейс поверх сцены
                GameUIView()
            }
            .onAppear {
                // Инициализируем сцену при появлении представления
                if gameScene == nil {
                    let scene = GameScene(size: geometry.size)
                    scene.scaleMode = .aspectFill
                    gameScene = scene
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
