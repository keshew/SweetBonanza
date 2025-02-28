import SwiftUI
import SpriteKit

class SweetGameShakeData: ObservableObject {
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
    @Published var mixingValue = 0
    @Published var scene = SKScene()
}

class SweetGameShakeSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: SweetGameShakeData?
    var selectedNode: SKSpriteNode?
    var whiskNode: SKSpriteNode?
    var isWhisking: Bool = false
    var whiskStartLocation: CGPoint?
    var potNode: SKSpriteNode?
    var progressNode: SKShapeNode!
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
        
        let desckWithWhicke = SKSpriteNode(imageNamed: SweetImageName.deskWithWhisk.rawValue)
        desckWithWhicke.size = CGSize(width: size.width * 0.229, height: size.height * 0.165)
        desckWithWhicke.name = "desckWithWhicke"
        desckWithWhicke.position = CGPoint(x: size.width / 1.126, y: size.height / 1.5)
        addChild(desckWithWhicke)
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
        
        let pot = SKSpriteNode(imageNamed: SweetImageName.shakeBowl1.rawValue)
        pot.size = CGSize(width: size.width * 0.712, height: size.height * 0.237)
        pot.name = "pot"
        pot.position = CGPoint(x: size.width / 2, y: size.height / 8.7)
        addChild(pot)
        potNode = pot
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
        let requiredTaps: Int = 5
        let totalWidth: CGFloat = 261
        let startPosition: CGFloat = size.width / 1.7 - totalWidth / 2
        let endPosition: CGFloat = size.width / 1.7 + totalWidth / 2

        let mixingMaxValue: Int = 10
        if game!.mixingValue < requiredTaps {
            let progress: CGFloat = CGFloat(game!.mixingValue) / CGFloat(requiredTaps)
            let newX: CGFloat = startPosition + (endPosition - startPosition) * progress * 0.5
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
            potNode?.texture = SKTexture(imageNamed: SweetImageName.shakeBowl1.rawValue)
        } else if game!.mixingValue == requiredTaps {
            let newX: CGFloat = endPosition - (totalWidth * 0.5)
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
            potNode?.texture = SKTexture(imageNamed: SweetImageName.shakeBowl2.rawValue)
        } else if game!.mixingValue > requiredTaps && game!.mixingValue <= mixingMaxValue {
            let progress: CGFloat = CGFloat(game!.mixingValue) / CGFloat(mixingMaxValue)
            let newX: CGFloat = startPosition + (endPosition - startPosition) * progress
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
            potNode?.texture = SKTexture(imageNamed: SweetImageName.shakeBowl3.rawValue)
        }

        if game!.mixingValue >= mixingMaxValue {
            game!.mixingValue = mixingMaxValue 
        }
    }
    
    func checkMixingResult() {
        if game!.mixingValue == 5 {
            game!.isWin = true
        } else if game!.mixingValue > 0, game!.mixingValue < 5 {
            game!.isLoseEarly = true
        } else if game!.mixingValue > 5 {
            game!.isLoseLate = true
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
            whiskStartLocation = location
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "desckWithWhicke" {
                tappedNode.removeFromParent()
                whiskNode = SKSpriteNode(imageNamed: SweetImageName.whisk.rawValue)
                whiskNode?.size = CGSize(width: 140, height: 175)
                whiskNode?.name = "whisk"
                whiskNode?.position = CGPoint(x: size.width / 1.4, y: size.height / 3)
                addChild(whiskNode!)
            } else if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "whisk" {
                whiskNode = tappedNode
            }
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "helpButton" {
                game!.isHelp = true
            }
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "pauseButton" {
                game!.isPause = true
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = whiskNode {
            node.position = location
            
            if let pot = potNode {
                let potRect = CGRect(x: pot.position.x - pot.size.width / 2, y: pot.position.y - pot.size.height / 2, width: pot.size.width, height: pot.size.height)
                
                if potRect.contains(location) {
                    if let startLocation = whiskStartLocation {
                        let deltaY = location.y - startLocation.y
                        
                        if abs(deltaY) > 20 && !isWhisking {
                            isWhisking = true
                            game!.mixingValue += 1
                            updateProgressNode()
                        } else if abs(deltaY) < 10 {
                            isWhisking = false
                        }
                    }
                } else {
                    isWhisking = false
                }
            }
            
            whiskStartLocation = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        whiskNode = nil
        whiskStartLocation = nil
        isWhisking = false
        
        if game!.mixingValue > 0 {
            checkMixingResult()
        }
    }
}
struct SweetGameShakeView: View {
    @StateObject var sweetGameShakeModel =  SweetGameShakeViewModel()
    @StateObject var gameModel =  SweetGameShakeData()
    let dish: RecipeModel
    var body: some View {
        ZStack {
            SpriteView(scene: sweetGameShakeModel.createSweetGameShakeScene(gameData: gameModel, dish: dish))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            if gameModel.isHelp {
                SweetShakeRulesView(game: gameModel, scene: gameModel.scene)
            }
            
            if gameModel.isPause {
                SweetPauseView(isPause: $gameModel.isPause, scene: gameModel.scene, dish: dish)
            }
            
            if gameModel.isWin {
                SweetGameCakeView(dish: dish)
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
    SweetGameShakeView(dish: dish)
}

