import SwiftUI
import SpriteKit

class SweetGameCakeData: ObservableObject {
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

class SweetGameCakeSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: SweetGameCakeData?
    var progressNode: SKShapeNode!
    var timerAction: SKAction!
    var pot: SKSpriteNode!
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
        
        let cakeButton = SKSpriteNode(imageNamed: SweetImageName.getCakeButton.rawValue)
        cakeButton.size = CGSize(width: 301, height: 53)
        cakeButton.name = "cakeButton"
        cakeButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cakeButton)
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
        
        
        pot = SKSpriteNode(imageNamed: SweetImageName.cakeDoing1.rawValue)
        pot.size = CGSize(width: 324, height: 310)
        pot.name = "pot"
        pot.position = CGPoint(x: size.width / 2, y: size.height / 5.2)
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
            pot.texture = SKTexture(imageNamed: SweetImageName.cakeDoing1.rawValue)
        } else if game!.countTap == requiredTaps {
            let newX: CGFloat = endPosition - (totalWidth * 0.5)
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
            pot.texture = SKTexture(imageNamed: SweetImageName.cakeDoing2.rawValue)
        } else if game!.countTap > requiredTaps, game!.countTap <= maxTaps {
            let progress: CGFloat = CGFloat(game!.countTap) / CGFloat(maxTaps)
            let newX: CGFloat = startPosition + (endPosition - startPosition) * progress
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
            pot.texture = SKTexture(imageNamed: SweetImageName.cakeDoing3.rawValue)
        }
        
        if game!.countTap >= maxTaps {
            game!.countTap = maxTaps
        }
    }
    
    func increaseTapCount() {
        if !game!.isHelp, !game!.isPause {
            game!.countTap += 1
            updateProgressNode()
        }
        
        if game!.isWin || game!.isLoseLate || game!.isLoseEarly {
            self.removeAction(forKey: "timer")
        }
        if game!.countTap >= 10 {
            self.removeAction(forKey: "timer")
        }
    }
    
    func createProgressNode() -> SKShapeNode {
        let node = SKShapeNode(rectOf: CGSize(width: 5, height: 21))
        node.fillColor = .white
        node.position = CGPoint(x: size.width / 1.7 - 130, y: size.height / 1.245)
        return node
    }
    
    override func didMove(to view: SKView) {
        size = UIScreen.main.bounds.size
        physicsWorld.contactDelegate = self
        setupView()
        timerAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.run {
                self.increaseTapCount()
            }
        ]))
        
        run(timerAction, withKey: "timer")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "pauseButton" {
                game!.isPause = true
            }
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "helpButton" {
                game!.isHelp = true
            }
            
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "cakeButton" {
                if game!.countTap == 5 {
                    game!.isWin = true
                } else if game!.countTap > 0, game!.countTap < 5 {
                    game!.isLoseEarly = true
                } else if game!.countTap > 5 {
                    game!.isLoseLate = true
                }
            }
        }
    }
}

struct SweetGameCakeView: View {
    @StateObject var sweetGameCakeModel =  SweetGameCakeViewModel()
    @StateObject var gameModel =  SweetGameCakeData()
    let dish: RecipeModel
    var body: some View {
        ZStack {
            SpriteView(scene: sweetGameCakeModel.createSweetGameCakeScene(gameData: gameModel, dish: dish))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            if gameModel.isHelp {
                SweetCakeRulesView(game: gameModel, scene: gameModel.scene)
            }
            
            if gameModel.isPause {
                SweetPauseView(isPause: $gameModel.isPause, scene: gameModel.scene, dish: dish)
            }
            
            if gameModel.isWin {
                SweetGameFillView(dish: dish)
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
    SweetGameCakeView(dish: dish)
}

