import SwiftUI

class SweetGameFillViewModel: ObservableObject {
    let contact = SweetGameFillModel()

    func createSweetGameFillcene(gameData: SweetGameFillData, dish: RecipeModel) -> SweetGameFillSpriteKit {
        let scene = SweetGameFillSpriteKit(dish: dish)
        scene.game  = gameData
        return scene
    }
}
