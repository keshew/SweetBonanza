import SwiftUI

class SweetGameCakeViewModel: ObservableObject {
    let contact = SweetGameCakeModel()

    func createSweetGameCakeScene(gameData: SweetGameCakeData, dish: RecipeModel) -> SweetGameCakeSpriteKit {
        let scene = SweetGameCakeSpriteKit(dish: dish)
        scene.game  = gameData
        return scene
    }
}
