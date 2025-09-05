import SpriteKit
import GameplayKit
import Combine

class GameScene: SKScene, ObservableObject {
    
    override func didMove(to view: SKView) {
        // Настройка сцены
        backgroundColor = SKColor.clear // Прозрачный фон, так как фон установлен в ContentView
        
        // Создание и настройка текста "Hello!"
        let helloLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        helloLabel.text = "Hello!"
        helloLabel.fontSize = 48
        helloLabel.fontColor = SKColor.white
        helloLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // Добавление текста на сцену
        addChild(helloLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Обработка касаний (можно расширить в будущем)
        for touch in touches {
            let location = touch.location(in: self)
            print("Касание в позиции: \(location)")
        }
    }
}
