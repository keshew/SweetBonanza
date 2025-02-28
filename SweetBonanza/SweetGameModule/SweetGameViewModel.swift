import SwiftUI

class SweetGameViewModel: ObservableObject {
    let contact = SweetGameModel()

    func createSweetGameScene(gameData: SweetGameData, dish: RecipeModel) -> SweetGameSpriteKit {
        let scene = SweetGameSpriteKit(dish: dish)
        scene.game  = gameData
        return scene
    }
}
