import SwiftUI

class SweetLevelViewModel: ObservableObject {
    let contact = SweetLevelModel()
    let gridItem = [GridItem(.flexible(), spacing: -20), GridItem(.flexible(), spacing: -20), GridItem(.flexible(), spacing: -20)]
    @StateObject var userDefaultsManager = UserDefaultsManager()
    @Published var selectedRecipe: RecipeModel = RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false)
    
    func loadSelectedRecipe() {
        if let recipe = userDefaultsManager.getRandomClosedItem() {
            selectedRecipe = recipe
        }
    }
}
