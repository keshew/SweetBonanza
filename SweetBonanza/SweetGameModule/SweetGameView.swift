import SwiftUI
import SpriteKit

class SweetGameData: ObservableObject {
    @Published var isPause = false
    @Published var isMenu = false
    @Published var isWin = false
    @Published var isLose = false
    @Published var isRules = false
    @Published var isHelp = false
    @Published var itemCount1 = 0
    @Published var itemCount2 = 0
    @Published var itemCount3 = 0
    @Published var itemCount4 = 0
    @Published var scene = SKScene()
}

class SweetGameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: SweetGameData?
    var itemLabel1: SKLabelNode!
    var itemLabel2: SKLabelNode!
    var itemLabel3: SKLabelNode!
    var itemLabel4: SKLabelNode!
    var timer: Timer?
    var selectedNode: SKSpriteNode?
    var progressNode: SKShapeNode!
    var touchStartLocation: CGPoint?
    let swipeThreshold: CGFloat = 50
    let dish: RecipeModel
    
    init(dish: RecipeModel) {
        self.dish = dish
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        createMainView()
        createTappedNodes()
        createMutationNodes()
        progressNode = createProgressNode()
        addChild(progressNode)
    }
    
    func createTappedNodes() {
        let helpButton = SKSpriteNode(imageNamed: SweetImageName.helpButton.rawValue)
        helpButton.size = CGSize(width: size.width * 0.112, height: size.height * 0.051)
        helpButton.name = "helpButton"
        helpButton.position = CGPoint(x: size.width / 10, y: size.height / 1.12)
        addChild(helpButton)
        
        let pauseButton = SKSpriteNode(imageNamed: SweetImageName.pauseButton.rawValue)
        pauseButton.size = CGSize(width: size.width * 0.112, height: size.height * 0.051)
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: size.width / 1.12, y: size.height / 1.12)
        addChild(pauseButton)
    }
    
    func createMainView() {
        let gameBackground = SKSpriteNode(imageNamed: SweetImageName.mainBack.rawValue)
        gameBackground.size = CGSize(width: size.width, height: size.height)
        gameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameBackground)
        
        let gameShadow = SKSpriteNode(imageNamed: SweetImageName.shadowMain.rawValue)
        gameShadow.size = CGSize(width: size.width, height: size.height)
        gameShadow.position = CGPoint(x: size.width / 2, y: size.height / 2.5)
        addChild(gameShadow)
        
        let itemToCook1 = SKSpriteNode(imageNamed: SweetImageName.itemToCook1.rawValue)
        itemToCook1.size = CGSize(width: 114, height: 90)
        itemToCook1.position = CGPoint(x: size.width / 4.5, y: size.height / 1.4)
        addChild(itemToCook1)
        
        let itemToCook2 = SKSpriteNode(imageNamed: SweetImageName.itemToCook2.rawValue)
        itemToCook2.size = CGSize(width: 114, height: 90)
        itemToCook2.position = CGPoint(x: size.width / 2.4, y: size.height / 1.4)
        addChild(itemToCook2)
        
        let itemToCook3 = SKSpriteNode(imageNamed: SweetImageName.itemToCook3.rawValue)
        itemToCook3.size = CGSize(width: 114, height: 90)
        itemToCook3.position = CGPoint(x: size.width / 1.63, y: size.height / 1.4)
        addChild(itemToCook3)
        
        let itemToCook4 = SKSpriteNode(imageNamed: SweetImageName.itemToCook4.rawValue)
        itemToCook4.size = CGSize(width: 114, height: 90)
        itemToCook4.position = CGPoint(x: size.width / 1.23, y: size.height / 1.4)
        addChild(itemToCook4)
        
        let pot = SKSpriteNode(imageNamed: SweetImageName.pot.rawValue)
        pot.size = CGSize(width: 330, height: 177)
        pot.name = "pot"
        pot.zPosition = 3
        pot.physicsBody = SKPhysicsBody(rectangleOf: pot.size)
        pot.physicsBody?.isDynamic = false
        pot.physicsBody?.categoryBitMask = 1
        pot.physicsBody?.contactTestBitMask = 2
        pot.position = CGPoint(x: size.width / 2, y: size.height / 10)
        addChild(pot)
    }
    
    func createMutationNodes() {
        let recept = SKSpriteNode(imageNamed: dish.image)
        recept.size = CGSize(width: size.width * 0.166, height: size.height * 0.086)
        recept.position = CGPoint(x: size.width / 7, y: size.height / 1.25)
        addChild(recept)
        
        let timeLine = SKSpriteNode(imageNamed: SweetImageName.timeLine.rawValue)
        timeLine.size = CGSize(width: size.width * 0.665, height: size.height * 0.025)
        timeLine.position = CGPoint(x: size.width / 1.7, y: size.height / 1.245)
        addChild(timeLine)
        
        itemLabel1 = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        itemLabel1.attributedText = NSAttributedString(string: "\(game?.itemCount1 ?? 0)/2", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -4
        ])
        itemLabel1.position = CGPoint(x: size.width / 4.5, y: size.height / 1.57)
        addChild(itemLabel1)
        
        itemLabel2 = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        itemLabel2.attributedText = NSAttributedString(string: "\(game?.itemCount2 ?? 0)/1", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -4
        ])
        itemLabel2.position = CGPoint(x: size.width / 2.4, y: size.height / 1.57)
        addChild(itemLabel2)
        
        itemLabel3 = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        itemLabel3.attributedText = NSAttributedString(string: "\(game?.itemCount3 ?? 0)/1", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -4
        ])
        itemLabel3.position = CGPoint(x: size.width / 1.64, y: size.height / 1.57)
        addChild(itemLabel3)
        
        itemLabel4 = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        itemLabel4.attributedText = NSAttributedString(string: "\(game?.itemCount4 ?? 0)/1", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -4
        ])
        itemLabel4.position = CGPoint(x: size.width / 1.24, y: size.height / 1.57)
        addChild(itemLabel4)
    }
    
    func getRandomImageName() -> String {
        return [SweetImageName.fruit1.rawValue,
                SweetImageName.fruit2.rawValue,
                SweetImageName.fruit3.rawValue,
                SweetImageName.fruit4.rawValue,
                SweetImageName.fruit5.rawValue,
                SweetImageName.fruit6.rawValue,
                SweetImageName.fruit7.rawValue].randomElement() ?? ""
    }
    
    func createFallingNode() -> SKSpriteNode? {
        if game!.isPause || game!.isHelp {
            return nil
        } else {
            let imageName = getRandomImageName()
            let node = SKSpriteNode(imageNamed: imageName)
            node.size = CGSize(width: 50, height: 50)
            node.name = imageName
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = true
            node.physicsBody?.categoryBitMask = 2
            node.physicsBody?.contactTestBitMask = 1
            node.physicsBody?.collisionBitMask = 0
            node.position = CGPoint(x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50), y: UIScreen.main.bounds.height)
            let moveAction = SKAction.move(to: CGPoint(x: node.position.x, y: -node.size.height), duration: 5.0)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            node.run(sequence)
            
            return node
        }
    }
    
    func updateProgressNode() {
        let requiredFruits: Int = 5
        let collectedFruits: Int = (game?.itemCount1 ?? 0) + (game?.itemCount2 ?? 0) + (game?.itemCount3 ?? 0) + (game?.itemCount4 ?? 0)
        let totalWidth: CGFloat = 261
        let startPosition: CGFloat = size.width / 1.7 - totalWidth / 2
        let endPosition: CGFloat = size.width / 1.7 + totalWidth / 2
        if collectedFruits < requiredFruits {
            let progress: CGFloat = CGFloat(collectedFruits) / CGFloat(requiredFruits)
            let newX: CGFloat = startPosition + (endPosition - startPosition) * progress * 0.5
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        } else if collectedFruits == requiredFruits {
            let newX: CGFloat = endPosition - (totalWidth * 0.5)
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        } else if collectedFruits > requiredFruits {
            let newX: CGFloat = endPosition - (totalWidth * 0.015)
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        }
    }
    
    func createProgressNode() -> SKShapeNode {
        let node = SKShapeNode(rectOf: CGSize(width: 5, height: 21))
        node.fillColor = .white
        node.position = CGPoint(x: size.width / 1.7 - 130, y: size.height / 1.245)
        return node
    }
    
    func checkIfAllFruitsCollected() {
        let item1Collected = (game?.itemCount1 ?? 0) >= 2
        let item2Collected = (game?.itemCount2 ?? 0) >= 1
        let item3Collected = (game?.itemCount3 ?? 0) >= 1
        let item4Collected = (game?.itemCount4 ?? 0) >= 1

        let item1Excess = (game?.itemCount1 ?? 0) > 2
        let item2Excess = (game?.itemCount2 ?? 0) > 1
        let item3Excess = (game?.itemCount3 ?? 0) > 1
        let item4Excess = (game?.itemCount4 ?? 0) > 1
        
        if item1Collected && item2Collected && item3Collected && item4Collected {
            game!.isWin = true
            scene?.isPaused = true
            if item1Excess || item2Excess || item3Excess || item4Excess {
                game!.isLose = true
            }
        }
    }
    
    override func didMove(to view: SKView) {
        size = UIScreen.main.bounds.size
        physicsWorld.contactDelegate = self
        setupView()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if let node = self.createFallingNode() {
                self.addChild(node)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case 1 | 2:
            let fruitNode: SKSpriteNode?
            
            if let nodeA = contact.bodyA.node as? SKSpriteNode, nodeA.name == "pot" {
                fruitNode = contact.bodyB.node as? SKSpriteNode
            } else if let nodeB = contact.bodyB.node as? SKSpriteNode, nodeB.name == "pot" {
                fruitNode = contact.bodyA.node as? SKSpriteNode
            } else {
                return
            }
            
            guard let fruitNode = fruitNode else { return }
            
            if let fruitName = fruitNode.name {
                switch fruitName {
                case SweetImageName.fruit1.rawValue:
                    game?.itemCount1 += 1
                    itemLabel1.attributedText = NSAttributedString(string: "\(game?.itemCount1 ?? 0)/2", attributes: [
                        NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
                        NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
                        NSAttributedString.Key.strokeColor: UIColor.white,
                        NSAttributedString.Key.strokeWidth: -4
                    ])
                case SweetImageName.fruit2.rawValue:
                    game?.itemCount2 += 1
                    itemLabel2.attributedText = NSAttributedString(string: "\(game?.itemCount2 ?? 0)/1", attributes: [
                        NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
                        NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
                        NSAttributedString.Key.strokeColor: UIColor.white,
                        NSAttributedString.Key.strokeWidth: -4
                    ])
                case SweetImageName.fruit6.rawValue:
                    game?.itemCount3 += 1
                    itemLabel3.attributedText = NSAttributedString(string: "\(game?.itemCount3 ?? 0)/1", attributes: [
                        NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
                        NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
                        NSAttributedString.Key.strokeColor: UIColor.white,
                        NSAttributedString.Key.strokeWidth: -4
                    ])
                case SweetImageName.fruit4.rawValue:
                    game?.itemCount4 += 1
                    itemLabel4.attributedText = NSAttributedString(string: "\(game?.itemCount4 ?? 0)/1", attributes: [
                        NSAttributedString.Key.font: UIFont(name: "Puffy", size: size.width * 0.07634)!,
                        NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 0/255, blue: 170/255, alpha: 1),
                        NSAttributedString.Key.strokeColor: UIColor.white,
                        NSAttributedString.Key.strokeWidth: -4
                    ])
                default:
                    break
                }
            }
            
            fruitNode.removeFromParent()
            updateProgressNode()
            checkIfAllFruitsCollected()
        default:
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "pauseButton" {
            game!.isPause = true
            game!.scene = scene!
            scene!.isPaused = true
        }
        
        if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "helpButton" {
            game!.isHelp = true
            game!.scene = scene!
            scene!.isPaused = true
        }
        
        if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name != "pot", tappedNode.name != "pauseButton", tappedNode.name != "helpButton" {
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, ((tappedNode.name?.starts(with: "fruit")) != nil) {
                selectedNode = tappedNode
                selectedNode?.removeAllActions()
                selectedNode?.physicsBody = nil
                touchStartLocation = location
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = selectedNode {
            node.position = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedNode = selectedNode, let startLocation = touchStartLocation else {
            return
        }
        let endLocation = touch.location(in: self)
        let horizontalSwipeDistance = endLocation.x - startLocation.x
        if abs(horizontalSwipeDistance) > swipeThreshold {
            selectedNode.removeFromParent()
        } else {
            let validSelectedNode: SKSpriteNode = selectedNode
            validSelectedNode.physicsBody = SKPhysicsBody(rectangleOf: validSelectedNode.size)
            validSelectedNode.physicsBody?.isDynamic = true
            validSelectedNode.physicsBody?.categoryBitMask = 2
            validSelectedNode.physicsBody?.contactTestBitMask = 1
            
            let moveAction = SKAction.move(to: CGPoint(x: validSelectedNode.position.x, y: -validSelectedNode.size.height), duration: 5.0)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            validSelectedNode.run(sequence)
            
            self.selectedNode = nil
        }
        
        self.selectedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode = nil
        let _ = touchStartLocation
    }
}

struct SweetGameView: View {
    @StateObject var sweetGameModel =  SweetGameViewModel()
    @StateObject var gameModel =  SweetGameData()
    var dish: RecipeModel
    var body: some View {
        ZStack {
            SpriteView(scene: sweetGameModel.createSweetGameScene(gameData: gameModel,dish: dish))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            if gameModel.isPause {
                SweetPauseView(isPause: $gameModel.isPause, scene: gameModel.scene, dish: dish)
            }
            
            if gameModel.isHelp {
                SweetCatchRulesView(game: gameModel, scene: gameModel.scene)
            }
            
            if gameModel.isWin {
                SweetGameEggView(dish: dish)
            }
            
            if gameModel.isLose {
                SweetLoseLateView(dish: dish)
            }
        }
    }
}

#Preview {
    let dish = RecipeModel(image: SweetImageName.dish1.rawValue, detailRecipe: "", isOpen: false)
    SweetGameView(dish: dish)
}
