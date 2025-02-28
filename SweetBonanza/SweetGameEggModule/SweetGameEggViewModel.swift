import SwiftUI

class SweetGameEggViewModel: ObservableObject {
    let contact = SweetGameEggModel()

    func createSweetGameEggScene(gameData: SweetGameEggData, dish: RecipeModel) -> SweetGameEggSpriteKit {
        let scene = SweetGameEggSpriteKit(dish: dish)
        scene.game  = gameData
        return scene
    }
}
