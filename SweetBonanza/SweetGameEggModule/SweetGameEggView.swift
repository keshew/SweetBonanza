import SwiftUI
import SpriteKit

class SweetGameEggData: ObservableObject {
    @Published var isPause = false
    @Published var isMenu = false
    @Published var isWin = false
    @Published var isLoseEarly = false
    @Published var isLoseLate = false
    @Published var isRules = false
    @Published var isHelp = false
    @Published var itemCount1 = 0
    @Published var itemCount2 = 0
    @Published var itemCount3 = 0
    @Published var itemCount4 = 0
    @Published var countTap = 0
    @Published var scene = SKScene()
}

class SweetGameEggSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: SweetGameEggData?
    var egg: SKSpriteNode!
    var touchStartLocation: CGPoint?
    var touchEndLocation: CGPoint?
    var progressNode: SKShapeNode!
    var fallingNode: SKSpriteNode!
    var isSwipe: Bool = false
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
        
        egg = SKSpriteNode(imageNamed: SweetImageName.egg1.rawValue)
        egg.size = CGSize(width: 150, height: 122)
        egg.name = "egg"
        egg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(egg)
    }
    
    func createMainView() {
        let gameBackground = SKSpriteNode(imageNamed:  UserDefaultsManager().selectedSweetImage() ?? SweetImageName.mainBack.rawValue)
        gameBackground.size = CGSize(width: size.width, height: size.height)
        gameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameBackground)
        
        let gameShadow = SKSpriteNode(imageNamed: SweetImageName.shadowMain.rawValue)
        gameShadow.size = CGSize(width: size.width, height: size.height)
        gameShadow.position = CGPoint(x: size.width / 2, y: size.height / 2.5)
        addChild(gameShadow)
        
        let pot = SKSpriteNode(imageNamed: SweetImageName.bowl.rawValue)
        pot.size = CGSize(width: 274, height: 190)
        pot.name = "pot"
        pot.position = CGPoint(x: size.width / 2, y: size.height / 8.5)
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
    }
    
    func createProgressNode() -> SKShapeNode {
        let node = SKShapeNode(rectOf: CGSize(width: 5, height: 21))
        node.fillColor = .white
        node.position = CGPoint(x: size.width / 1.7 - 130, y: size.height / 1.245)
        return node
    }
    
    func updateProgressNode() {
        let maxTaps: Int = 10
        let requiredTaps: Int = 5
        let totalWidth: CGFloat = 261
        let startPosition: CGFloat = size.width / 1.7 - totalWidth / 2
        let endPosition: CGFloat = size.width / 1.7 + totalWidth / 2
        
        if game!.countTap < requiredTaps {
            let progress: CGFloat = CGFloat(game!.countTap) / CGFloat(requiredTaps)
            let newX: CGFloat = startPosition + (endPosition - startPosition) * progress * 0.5
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        } else if game!.countTap == requiredTaps {
            let newX: CGFloat = endPosition - (totalWidth * 0.5)
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        } else if game!.countTap > requiredTaps, game!.countTap <= maxTaps {
            let progress: CGFloat = CGFloat(game!.countTap) / CGFloat(maxTaps)
            let newX: CGFloat = startPosition + (endPosition - startPosition) * progress
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        }

        if game!.countTap >= maxTaps {
            game!.countTap = maxTaps
        }
    }
    
    override func didMove(to view: SKView) {
        size = UIScreen.main.bounds.size
        physicsWorld.contactDelegate = self
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchStartLocation = location
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "pauseButton" {
                game!.isPause = true
            }
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "helpButton" {
                game!.isHelp = true
            }
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "egg" {
                tappedNode.texture = SKTexture(imageNamed: SweetImageName.egg2.rawValue)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let startLocation = touchStartLocation{
            let endLocation = location
            let deltaY = endLocation.y - startLocation.y
            
            if deltaY < 0 {
                isSwipe = true
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        touchEndLocation = location
        if let eggNode = self.atPoint(location) as? SKSpriteNode, eggNode.name == "egg" {
            if let startLocation = touchStartLocation, let endLocation = touchEndLocation {
                let deltaY = endLocation.y - startLocation.y
                
                if deltaY < 0 {
                    let changeTextureAction = SKAction.run {
                        eggNode.texture = SKTexture(imageNamed: SweetImageName.egg3.rawValue)
                        eggNode.size = CGSize(width: 250, height: 213)
                    }
                    let removeAction = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([changeTextureAction, removeAction])
                    eggNode.run(sequence) {
                        if self.game!.countTap == 5 {
                            self.fallingNode = SKSpriteNode(imageNamed: SweetImageName.egg5.rawValue)
                            self.fallingNode.size = CGSize(width: 150, height: 87)
                            self.fallingNode.position = eggNode.position
                            self.addChild(self.fallingNode)
                            
                            let moveAction = SKAction.move(to: CGPoint(x: self.fallingNode.position.x, y: self.size.height / 5.5), duration: 2.0)
                            let sequence2 = SKAction.sequence([moveAction])
                            self.fallingNode.run(sequence2) {
                                self.game!.isWin = true
                            }
                        } else {
                            self.fallingNode = SKSpriteNode(imageNamed: SweetImageName.egg4.rawValue)
                            self.fallingNode.size = CGSize(width: 150, height: 87)
                            self.fallingNode.position = eggNode.position
                            self.addChild(self.fallingNode)
                            
                            let moveAction = SKAction.move(to: CGPoint(x: self.fallingNode.position.x, y: self.size.height / 5.5), duration: 2.0)
                            let sequence2 = SKAction.sequence([moveAction])
                            self.fallingNode.run(sequence2) {
                                if self.game!.countTap < 5 {
                                    self.game!.isLoseEarly = true
                                } else if self.game!.countTap > 5 {
                                    self.game?.isLoseLate = true
                                }
                            }
                        }
                    }
                }
            }
            
            if !isSwipe {
                game!.countTap += 1
                updateProgressNode()
            }
            
            isSwipe = false
        }
        
        touchStartLocation = nil
        touchEndLocation = nil
    }
}

struct SweetGameEggView: View {
    @StateObject var sweetGameEggModel =  SweetGameEggViewModel()
    @StateObject var gameModel =  SweetGameEggData()
    let dish: RecipeModel
    var body: some View {
        ZStack {
            SpriteView(scene: sweetGameEggModel.createSweetGameEggScene(gameData: gameModel, dish: dish))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                
            if gameModel.isHelp {
                SweetEggRulesView(game: gameModel, scene: gameModel.scene)
            }
            
            if gameModel.isPause {
                SweetPauseView(isPause: $gameModel.isPause, scene: gameModel.scene, dish: dish)
            }
            
            if gameModel.isWin {
                SweetGameShakeView(dish: dish)
            }
            
            if gameModel.isLoseLate {
                SweetLoseLateView(dish: dish)
            }
            
            if gameModel.isLoseEarly {
                SweetLoseEarlyView(dish: dish)
            }
        }
    }
}

#Preview {
    let dish = RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false)
    SweetGameEggView(dish: dish)
}

