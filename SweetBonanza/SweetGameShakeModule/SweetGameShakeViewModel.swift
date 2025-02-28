import SwiftUI

class SweetGameShakeViewModel: ObservableObject {
    let contact = SweetGameShakeModel()
    
    func createSweetGameShakeScene(gameData: SweetGameShakeData, dish: RecipeModel) -> SweetGameShakeSpriteKit {
        let scene = SweetGameShakeSpriteKit(dish: dish)
        scene.game  = gameData
        return scene
    }
}
