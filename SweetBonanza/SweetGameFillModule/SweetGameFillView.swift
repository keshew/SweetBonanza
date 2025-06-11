import SwiftUI
import SpriteKit

class SweetGameFillData: ObservableObject {
    @Published var isPause = false
    @Published var isMenu = false
    @Published var isWin = false
    @Published var isLoseEarly = false
    @Published var isLoseLate = false
    @Published var isRules = false
    @Published var isHelp = false
    @Published var scene = SKScene()
}

class SweetGameFillSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: SweetGameFillData?
    var selectedNode: SKSpriteNode?
    var fillItem: SKSpriteNode?
    var cupcakeNodes: [SKSpriteNode] = []
    var timer: Timer?
    var timers: [SKSpriteNode: Timer] = [:]
    var progressNode: SKShapeNode!
    var progressSteps: Int = 0
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
        
        let deskFillItem = SKSpriteNode(imageNamed: SweetImageName.deskFillItem.rawValue)
        deskFillItem.size = CGSize(width: 90, height: 125)
        deskFillItem.name = "deskFillItem"
        deskFillItem.position = CGPoint(x: size.width / 1.126, y: size.height / 1.5)
        addChild(deskFillItem)
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
        
        let pot = SKSpriteNode(imageNamed: SweetImageName.desk.rawValue)
        pot.size = CGSize(width: 360, height: 140)
        pot.name = "pot"
        pot.position = CGPoint(x: size.width / 2, y: size.height / 7)
        addChild(pot)
        
        let cc1 = SKSpriteNode(imageNamed: SweetImageName.cupcake1.rawValue)
        cc1.size = CGSize(width: 65, height: 54)
        cc1.position = CGPoint(x: size.width / 4.1, y: size.height / 7)
        cupcakeNodes.append(cc1)
        addChild(cc1)
        
        let cc2 = SKSpriteNode(imageNamed: SweetImageName.cupcake1.rawValue)
        cc2.size = CGSize(width: 65, height: 54)
        cc2.position = CGPoint(x: size.width / 2.4, y: size.height / 7)
        cupcakeNodes.append(cc2)
        addChild(cc2)
        
        let cc3 = SKSpriteNode(imageNamed: SweetImageName.cupcake1.rawValue)
        cc3.size = CGSize(width: 65, height: 54)
        cc3.position = CGPoint(x: size.width / 1.7, y: size.height / 7)
        cupcakeNodes.append(cc3)
        addChild(cc3)
        
        let cc4 = SKSpriteNode(imageNamed: SweetImageName.cupcake1.rawValue)
        cc4.size = CGSize(width: 65, height: 54)
        cc4.position = CGPoint(x: size.width / 1.31, y: size.height / 7)
        cupcakeNodes.append(cc4)
        addChild(cc4)
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
    
    func changeCupcakeTexture(_ cupcake: SKSpriteNode) {
        if cupcake.texture?.description.contains("cupcake1") ?? false {
            cupcake.texture = SKTexture(imageNamed: SweetImageName.cupcake2.rawValue)
            cupcake.size = CGSize(width: 65, height: 65)
            cupcake.position = CGPoint(x: cupcake.position.x, y: size.height / 6.75)
        } else if cupcake.texture?.description.contains("cupcake2") ?? false {
            cupcake.texture = SKTexture(imageNamed: SweetImageName.cupcake3.rawValue)
            cupcake.size = CGSize(width: 65, height: 80)
            cupcake.position = CGPoint(x: cupcake.position.x, y: size.height / 6.41)
        } else if cupcake.texture?.description.contains("cupcake3") ?? false {
            cupcake.texture = SKTexture(imageNamed: SweetImageName.cupcake4.rawValue)
            cupcake.size = CGSize(width: 65, height: 80)
            cupcake.position = CGPoint(x: cupcake.position.x, y: size.height / 6.41)
        }
        
        timer?.invalidate()
        timer = nil
    }
    
    func createProgressNode() -> SKShapeNode {
        let node = SKShapeNode(rectOf: CGSize(width: 5, height: 21))
        node.fillColor = .white
        node.position = CGPoint(x: size.width / 1.7 - 130, y: size.height / 1.245)
        return node
    }
    
    func updateProgressNode() {
        if progressSteps < 13 {
            let totalWidth: CGFloat = 261
            let startPosition: CGFloat = size.width / 1.7 - totalWidth / 2
            let endPosition: CGFloat = size.width / 1.7 + totalWidth / 2
            
            let stepWidth: CGFloat = (endPosition - startPosition) / 15
            
            let newX: CGFloat = startPosition + CGFloat(min(progressSteps, 15)) * stepWidth
            progressNode.position = CGPoint(x: newX, y: size.height / 1.245)
        }
    }
    
    func checkCupcakeResult() {
        var allCupcake3 = true
        var hasCupcake4 = false
        
        for cupcake in cupcakeNodes {
            if cupcake.texture?.description.contains("cupcake4") ?? false {
                hasCupcake4 = true
            }
            
            if !(cupcake.texture?.description.contains("cupcake3") ?? false) {
                allCupcake3 = false
            }
        }
        
        if hasCupcake4 {
            game!.isLoseLate = true
        } else if !allCupcake3 {
            game!.isLoseEarly = true
        } else {
            game!.isWin = true
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
            if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "deskFillItem" {
                tappedNode.removeFromParent()
                fillItem = SKSpriteNode(imageNamed: SweetImageName.fillItem.rawValue)
                fillItem?.size = CGSize(width: 140, height: 175)
                fillItem?.name = "fillItem"
                fillItem?.zRotation = 145
                fillItem?.position = CGPoint(x: size.width / 1.4, y: size.height / 3)
                addChild(fillItem!)
            } else if let tappedNode = self.atPoint(location) as? SKSpriteNode, tappedNode.name == "fillItem" {
                fillItem = tappedNode
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
        
        if let node = fillItem {
            node.position = location
            
            for cupcake in cupcakeNodes {
                let cupcakeRect = CGRect(x: cupcake.position.x - cupcake.size.width / 2, y: cupcake.position.y - cupcake.size.height / 2, width: cupcake.size.width, height: cupcake.size.height)
                
                let offsetRect = CGRect(x: cupcakeRect.minX - 10, y: cupcakeRect.minY, width: cupcakeRect.width + 20, height: cupcakeRect.height + 90)
                
                if offsetRect.contains(location) {
                    if timers[cupcake] == nil {
                        timers[cupcake] = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
                            self?.changeCupcakeTexture(cupcake)
                            self?.progressSteps += 1
                            self?.updateProgressNode()
                        }
                    }
                } else {
                    timers[cupcake]?.invalidate()
                    timers[cupcake] = nil
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fillItem = nil
        if progressSteps > 0 {
            checkCupcakeResult()
        }
    }
}

struct SweetGameFillView: View {
    @StateObject var sweetGameFillModel =  SweetGameFillViewModel()
    @StateObject var gameModel =  SweetGameFillData()
    let dish: RecipeModel
    var body: some View {
        ZStack {
            SpriteView(scene: sweetGameFillModel.createSweetGameFillcene(gameData: gameModel, dish: dish))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            if gameModel.isHelp {
                SweetFillRulesView(game: gameModel, scene: gameModel.scene)
            }
            
            if gameModel.isPause {
                SweetPauseView(isPause: $gameModel.isPause, scene: gameModel.scene, dish: dish)
            }
            
            if gameModel.isWin {
                SweetWinView(dish: dish)
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
    SweetGameFillView(dish: dish)
}

