import SpriteKit
import GameplayKit
import Combine

class GameScene: SKScene, ObservableObject {
    
    override func didMove(to view: SKView) {
        // Настройка сцены
        backgroundColor = SKColor.clear
        
        // Добавление фонового изображения
        let background = SKSpriteNode(imageNamed: "game_bg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // Масштабирование фона для заполнения всего экрана
        let backgroundAspectRatio = background.size.width / background.size.height
        let screenAspectRatio = frame.width / frame.height
        
        if backgroundAspectRatio > screenAspectRatio {
            // Фон шире экрана - подгоняем по ширине
            background.size = CGSize(width: frame.width, height: frame.width / backgroundAspectRatio)
        } else {
            // Фон выше экрана - подгоняем по высоте
            background.size = CGSize(width: frame.height * backgroundAspectRatio, height: frame.height)
        }
        
        background.zPosition = -1 // Помещаем фон за все остальные элементы
        addChild(background)
        
        // Запускаем спавн NPC
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnNPC),
                SKAction.wait(forDuration: TimeInterval.random(in: 1.0...2.5))
            ])
        ))
    }
    
    func spawnNPC() {
        let friendlyNPCs = ["woman_friendly", "man_friendly"]
        let monsterNPCs = ["devil_monstr", "green_monstr", "red_monstr", "smallGold_monstr"]
        
        // Решаем, кого спавнить: монстра или мирного жителя (например, 80% шанс на монстра)
        let isMonster = CGFloat.random(in: 0...1) < 0.8
        let npcImageName = isMonster ? monsterNPCs.randomElement()! : friendlyNPCs.randomElement()!
        
        // Создаем спрайт NPC
        // ВНИМАНИЕ: Убедитесь, что изображения с этими именами есть в Assets.xcassets
        let npc = SKSpriteNode(imageNamed: npcImageName)
        
        // Проверяем, загрузилась ли текстура
        if npc.texture == nil {
            print("!!! ОШИБКА: Не удалось загрузить текстуру для \(npcImageName). Проверьте имя ассета в Assets.xcassets.")
            return // Не спавним NPC, если текстура не загрузилась
        }
        
        // Задаем начальную позицию
        let randomX = CGFloat.random(in: frame.minX...frame.maxX)
        npc.position = CGPoint(x: randomX, y: frame.maxY + npc.size.height)
        
        // Масштабируем NPC, если нужно (подберите подходящий размер)
        npc.setScale(0.5)
        
        // Добавляем физическое тело для будущих столкновений
        npc.physicsBody = SKPhysicsBody(rectangleOf: npc.size)
        npc.physicsBody?.isDynamic = true
        npc.physicsBody?.affectedByGravity = false // Отключаем гравитацию, т.к. двигаем действием
        
        addChild(npc)
        
        // Создаем действие для движения вниз
        let duration = TimeInterval.random(in: 8.0...12.0) // Медленное движение
        let moveAction = SKAction.moveTo(y: frame.minY - npc.size.height, duration: duration)
        let removeAction = SKAction.removeFromParent()
        
        // Запускаем последовательность действий: движение, затем удаление
        npc.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Обработка касаний (можно расширить в будущем)
        for touch in touches {
            let location = touch.location(in: self)
            print("Касание в позиции: \(location)")
        }
    }
}
