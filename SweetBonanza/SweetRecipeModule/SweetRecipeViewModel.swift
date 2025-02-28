import SwiftUI

class SweetRecipeViewModel: ObservableObject {
    let contact = SweetRecipeModel()
    let gridItem = [GridItem(.flexible(), spacing: -100),
                    GridItem(.flexible(), spacing: -100),
                    GridItem(.flexible(), spacing: -100)]
    
    @Published var recipes: [RecipeModel] = []
    @Published var userDefaultsManager = UserDefaultsManager()
    
    init() {
        loadRecipes()
    }
    
    func loadRecipes() {
        recipes = userDefaultsManager.collectionItem
    }
}
