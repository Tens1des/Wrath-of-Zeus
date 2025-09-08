import SpriteKit
import GameplayKit
import Combine

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let wall: UInt32 = 0b10000
    static let lightning: UInt32 = 0b1 // 1
    static let friendlyNPC: UInt32 = 0b10 // 2
    static let scoreNPC: UInt32 = 0b100 // 4
    static let coinNPC: UInt32 = 0b1000 // 8
}

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    // Состояние игры
    @Published var charges: Int = 3
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isNewRecord: Bool = false
    
    // Статистика игрока
    @Published var totalCoins: Int = 0
    private(set) var sessionCoins: Int = 0 // Доступно для чтения, но не для записи извне
    private var highScore: Int = 0
    
    // Интеграция с магазином
    private let shopManager = ShopManager.shared
    
    private var zeusNode: SKSpriteNode!
    private var isAiming = false
    private var trajectoryNode: SKShapeNode!
    private var trajectoryPoints: [CGPoint] = []
    
    // Переменные для сложности
    private var gameTime: TimeInterval = 0
    private var lastDifficultyIncrease: TimeInterval = 0
    private var timeSinceLastSpawn: TimeInterval = 0
    
    private var spawnInterval: TimeInterval = 0.8
    private var moveDurationRange: ClosedRange<TimeInterval> = 6.0...9.0
    
    override init(size: CGSize) {
        super.init(size: size)
        loadGameStats()
        setupShopIntegration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // Настройка сцены
        backgroundColor = SKColor.clear
        
        // Назначаем делегата для обработки контактов
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        // Добавление фонового изображения
        let background = SKSpriteNode(imageNamed: "game_bg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size // Устанавливаем размер фона равным размеру сцены
        
        background.zPosition = -1 // Помещаем фон за все остальные элементы
        addChild(background)
        
        setupZeus()
        
        // Настройка узла для траектории
        trajectoryNode = SKShapeNode()
        trajectoryNode.strokeColor = .white
        trajectoryNode.lineWidth = 2
        trajectoryNode.zPosition = 5
        addChild(trajectoryNode)
        
        // Удаляем старый SKAction спавнер
        // run(SKAction.repeatForever(...))

        // Добавляем боковые стены для отскоков молнии
        addSideWalls()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isPaused else { return }
        
        // Инициализируем gameTime при первом запуске
        if self.gameTime == 0 {
            self.gameTime = currentTime
            self.lastDifficultyIncrease = currentTime
            self.timeSinceLastSpawn = currentTime
        }
        
        // Увеличиваем сложность каждые 15 секунд
        if currentTime - lastDifficultyIncrease > 15 {
            lastDifficultyIncrease = currentTime
            
            // Уменьшаем интервал спавна (минимально 0.5с)
            spawnInterval = max(0.5, spawnInterval * 0.9)
            
            // Увеличиваем скорость (уменьшаем время полета, минимально 3-5с)
            let newLowerBound = max(3.0, moveDurationRange.lowerBound * 0.9)
            let newUpperBound = max(5.0, moveDurationRange.upperBound * 0.9)
            moveDurationRange = newLowerBound...newUpperBound
            
            print("СЛОЖНОСТЬ УВЕЛИЧЕНА: Интервал спавна \(spawnInterval), Скорость \(moveDurationRange)")
        }
        
        // Логика спавна
        if currentTime - timeSinceLastSpawn > spawnInterval {
            timeSinceLastSpawn = currentTime
            spawnNPC()
            // Начальный буст спавна в первые секунды
            if currentTime - gameTime < 3 {
                spawnNPC()
            }
        }
    }
    
    func setupZeus() {
        zeusNode = SKSpriteNode(imageNamed: "zeus_stay")
        zeusNode.name = "zeusNode" // Добавляем имя для поиска
        // Масштабируем Зевса (подберите подходящий размер)
        let zeusHeight: CGFloat = 150
        let zeusAspectRatio = zeusNode.size.width / zeusNode.size.height
        zeusNode.size = CGSize(width: zeusHeight * zeusAspectRatio, height: zeusHeight)
        
        // Позиционируем внизу по центру
        zeusNode.position = CGPoint(x: frame.midX, y: zeusNode.size.height / 2 + 30) // +30 для небольшого отступа
        zeusNode.zPosition = 10
        addChild(zeusNode)
    }
    
    func setupShopIntegration() {
        // Синхронизируем монеты с магазином
        totalCoins = shopManager.totalCoins
        
        // Устанавливаем начальное количество зарядов на основе навыка
        charges = 3 + (shopManager.shotPowerLevel - 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Начинаем прицеливание, если коснулись Зевса
        if zeusNode.contains(location) {
            isAiming = true
            // ВНИМАНИЕ: Убедитесь, что "zeusShot_icon" есть в Assets.xcassets
            zeusNode.texture = SKTexture(imageNamed: "zeusShot_icon")
            trajectoryPoints.removeAll()
            trajectoryPoints.append(zeusNode.position)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isAiming, let touch = touches.first else { return }
            let location = touch.location(in: self)
        
        // Обновляем конечную точку и перерисовываем траекторию
        if trajectoryPoints.count > 1 {
            trajectoryPoints[1] = location
        } else {
            trajectoryPoints.append(location)
        }
        drawTrajectory()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isAiming, let touch = touches.first else { return }
        isAiming = false
        trajectoryNode.path = nil // Стираем траекторию
        
        // Возвращаем текстуру Зевса после небольшой задержки
        let waitAction = SKAction.wait(forDuration: 0.3)
        let changeTextureAction = SKAction.run { [weak self] in
            self?.zeusNode.texture = SKTexture(imageNamed: "zeus_stay")
        }
        zeusNode.run(SKAction.sequence([waitAction, changeTextureAction]))
        
        let endLocation = touch.location(in: self)
        fireLightning(from: zeusNode.position, to: endLocation)
    }
    
    func drawTrajectory() {
        guard trajectoryPoints.count > 1 else { return }
        let startPoint = trajectoryPoints[0]
        let endPoint = trajectoryPoints[1]
        
        let path = CGMutablePath()
        path.move(to: startPoint)
        
        // Рисуем пунктирную линию
        let pattern: [CGFloat] = [10.0, 10.0] // 10 поинтов линия, 10 поинтов разрыв
        let dashedPath = path.copy(dashingWithPhase: 0, lengths: pattern)
        
        // Инвертируем направление для выстрела
        let dx = startPoint.x - endPoint.x
        let dy = startPoint.y - endPoint.y
        let invertedEndPoint = CGPoint(x: startPoint.x + dx, y: startPoint.y + dy)
        
        let finalPath = CGMutablePath()
        finalPath.move(to: startPoint)
        finalPath.addLine(to: invertedEndPoint)
        let finalDashedPath = finalPath.copy(dashingWithPhase: 0, lengths: pattern)

        trajectoryNode.path = finalDashedPath
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
        
        // Задаем начальную позицию с отступами
        let spawnMargin: CGFloat = 30.0
        let randomX = CGFloat.random(in: (frame.minX + spawnMargin)...(frame.maxX - spawnMargin))
        npc.position = CGPoint(x: randomX, y: frame.maxY + npc.size.height)
        
        // Масштабируем NPC, если нужно (подберите подходящий размер)
        npc.setScale(0.5)
        
        // Добавляем физическое тело для будущих столкновений
        npc.physicsBody = SKPhysicsBody(rectangleOf: npc.size)
        npc.physicsBody?.isDynamic = true
        npc.physicsBody?.affectedByGravity = false // Отключаем гравитацию, т.к. двигаем действием
        npc.physicsBody?.allowsRotation = false // Запрещаем вращение
        
        // Настройка физических категорий
        switch npcImageName {
        case "man_friendly", "woman_friendly":
            npc.physicsBody?.categoryBitMask = PhysicsCategory.friendlyNPC
        case "red_monstr", "green_monstr":
            npc.physicsBody?.categoryBitMask = PhysicsCategory.scoreNPC
        case "smallGold_monstr", "devil_monstr":
            npc.physicsBody?.categoryBitMask = PhysicsCategory.coinNPC
        default:
            npc.physicsBody?.categoryBitMask = PhysicsCategory.none
        }
        
        npc.physicsBody?.contactTestBitMask = PhysicsCategory.lightning
        npc.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        addChild(npc)
        
        // Создаем действие для движения вниз
        let duration = TimeInterval.random(in: moveDurationRange)
        let moveAction = SKAction.moveTo(y: frame.minY - npc.size.height, duration: duration)
        let removeAction = SKAction.removeFromParent()
        
        // Действие для проверки, дошел ли монстр до конца
        let checkEndAction = SKAction.run { [weak self] in
            // Проверяем, не закончилась ли уже игра
            guard self?.isGameOver == false else { return }
            
            let npcCategory = npc.physicsBody?.categoryBitMask
            if npcCategory == PhysicsCategory.scoreNPC || npcCategory == PhysicsCategory.coinNPC {
                print("GAME OVER: Монстр дошел до конца")
                self?.endGame()
            }
        }
        
        // Запускаем последовательность действий: движение, затем проверка, затем удаление
        npc.run(SKAction.sequence([moveAction, checkEndAction, removeAction]))
    }
    
    func fireLightning(from start: CGPoint, to end: CGPoint) {
        guard charges > 0 else {
            return // Не стреляем, если нет зарядов
        }
        
        charges -= 1
        
        // Запускаем регенерацию через 3 секунд (уменьшаем на основе навыка)
        let reloadTime = max(1.0, 3.0 - (Double(shopManager.reloadSpeedLevel - 1) * 0.5))
        Timer.scheduledTimer(withTimeInterval: reloadTime, repeats: false) { [weak self] _ in
            guard let self = self, self.charges < (3 + (self.shopManager.shotPowerLevel - 1)) else { return }
            self.charges += 1
        }
        
        // ВНИМАНИЕ: Убедитесь, что скины молний есть в Assets.xcassets
        let lightningSkin = shopManager.getActiveLightningSkin()
        let lightning = SKSpriteNode(imageNamed: lightningSkin)
        lightning.position = start
        lightning.setScale(0.5) // Подберите масштаб
        lightning.zPosition = 15
        
        // Настройка физического тела молнии
        lightning.physicsBody = SKPhysicsBody(circleOfRadius: max(lightning.size.width, lightning.size.height) / 2)
        lightning.physicsBody?.isDynamic = true
        lightning.physicsBody?.affectedByGravity = false
        lightning.physicsBody?.usesPreciseCollisionDetection = true
        lightning.physicsBody?.restitution = 1.0
        lightning.physicsBody?.friction = 0.0
        lightning.physicsBody?.linearDamping = 0.0
        lightning.physicsBody?.angularDamping = 0.0
        lightning.physicsBody?.allowsRotation = false
        lightning.physicsBody?.categoryBitMask = PhysicsCategory.lightning
        lightning.physicsBody?.contactTestBitMask = PhysicsCategory.friendlyNPC | PhysicsCategory.scoreNPC | PhysicsCategory.coinNPC
        lightning.physicsBody?.collisionBitMask = PhysicsCategory.wall
        
        // Расчет направления и установка скорости
        let dx = end.x - start.x
        let dy = end.y - start.y
        let angle = atan2(dy, dx)
        lightning.zRotation = angle - .pi / 2
        let speed: CGFloat = 900.0
        let velocity = CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
        addChild(lightning)
        lightning.physicsBody?.velocity = velocity
        
        // Автоудаление через 2 сек, чтобы не висела бесконечно
        lightning.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Проверяем, что столкнулись молния и какой-то NPC
        if (firstBody.categoryBitMask & PhysicsCategory.lightning) != 0 {
            if let npcNode = secondBody.node as? SKSpriteNode, let lightningNode = firstBody.node as? SKSpriteNode {
                handleCollision(lightning: lightningNode, npc: npcNode, npcBody: secondBody)
            }
        }
    }
    
    func handleCollision(lightning: SKSpriteNode, npc: SKSpriteNode, npcBody: SKPhysicsBody) {
        switch npcBody.categoryBitMask {
        case PhysicsCategory.friendlyNPC:
            // Проигрыш
            print("GAME OVER: Попал в дружелюбного NPC")
            endGame()
        case PhysicsCategory.scoreNPC:
            // +50 очков
            score += 50
            print("Score: \(score)")
        case PhysicsCategory.coinNPC:
            // +50 монет
            sessionCoins += 50
            totalCoins += 50
            shopManager.totalCoins = totalCoins // Синхронизируем с магазином
            print("Coins for session: \(sessionCoins), Total coins: \(totalCoins)")
        default:
            break
        }
        
        // Удаляем молнию и NPC, если игра не окончена
        if !isGameOver {
            lightning.removeFromParent()
            npc.removeFromParent()
        }
    }
    
    func endGame() {
        guard !isGameOver else { return } // Предотвращаем двойной вызов
        
        isGameOver = true
        self.view?.isPaused = true
        
        // Проверяем на новый рекорд
        if score > highScore {
            isNewRecord = true
            highScore = score
            print("NEW RECORD: \(highScore)")
        }
        
        // Сохраняем статистику
        saveGameStats()
    }
    

    private func addSideWalls() {
        // Remove existing walls
        childNode(withName: "leftWall")?.removeFromParent()
        childNode(withName: "rightWall")?.removeFromParent()
        // Left wall
        let leftWall = SKNode()
        leftWall.name = "leftWall"
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY),
                                             to: CGPoint(x: frame.minX, y: frame.maxY))
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        addChild(leftWall)
        // Right wall
        let rightWall = SKNode()
        rightWall.name = "rightWall"
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.maxX, y: frame.minY),
                                              to: CGPoint(x: frame.maxX, y: frame.maxY))
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        addChild(rightWall)
    }

    func updateSize(newSize: CGSize) {
        self.size = newSize
        
        // Удаляем старые узлы, чтобы избежать дублирования
        self.childNode(withName: "background")?.removeFromParent()
        self.childNode(withName: "zeusNode")?.removeFromParent()

        // Добавляем фон
        let background = SKSpriteNode(imageNamed: "game_bg")
        background.name = "background"
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        // Добавляем Зевса
        setupZeus()

        // Переинициализируем стены после изменения размера
        addSideWalls()
    }

    func restart(with size: CGSize) {
        // 1. Сбрасываем все игровые свойства
        charges = 3 + (shopManager.shotPowerLevel - 1) // Учитываем навык
        score = 0
        isGameOver = false
        isNewRecord = false
        sessionCoins = 0
        
        gameTime = 0
        lastDifficultyIncrease = 0
        timeSinceLastSpawn = 0
        
        spawnInterval = 2.5
        moveDurationRange = 10.0...14.0
        
        // 2. Удаляем все динамические узлы (NPC, молнии и т.д.)
        removeAllChildren()
        
        // 3. Пересоздаем сцену
        self.isPaused = false
        updateSize(newSize: size)
        
        // Пересоздаем узел траектории
        trajectoryNode = SKShapeNode()
        trajectoryNode.strokeColor = .white
        trajectoryNode.lineWidth = 2
        trajectoryNode.zPosition = 5
        addChild(trajectoryNode)

        // Загружаем статистику
        loadGameStats()
    }
    
    private func loadGameStats() {
        let defaults = UserDefaults.standard
        totalCoins = defaults.integer(forKey: "totalCoins")
        highScore = defaults.integer(forKey: "highScore")
        print("Stats loaded - Coins: \(totalCoins), High Score: \(highScore)")
    }
    
    private func saveGameStats() {
        let defaults = UserDefaults.standard
        defaults.set(totalCoins, forKey: "totalCoins")
        defaults.set(highScore, forKey: "highScore")
        print("Stats saved - Coins: \(totalCoins), High Score: \(highScore)")
    }
}
