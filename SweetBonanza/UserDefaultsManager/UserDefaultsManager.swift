import SwiftUI

enum Keys: String {
    case currentLevel = "currentLevel"
    case firstItems = "firstItems"
    case collectionItem = "collectionItem"
}

class UserDefaultsManager: ObservableObject {
    static let defaults = UserDefaults.standard
    @Published var collectionItem: [RecipeModel] = []
    @Published var images: [String] = []
    
    init() {
        loadCollectionItems()
        firstLaunch()
    }

    private func defaultRecipes() -> [RecipeModel] {
        return [RecipeModel(image: SweetImageName.dish1.rawValue, detailRecipe: SweetImageName.recept1.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: SweetImageName.recept2.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish3.rawValue, detailRecipe: SweetImageName.recept3.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish4.rawValue, detailRecipe: SweetImageName.recept4.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish5.rawValue, detailRecipe: SweetImageName.recept5.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish6.rawValue, detailRecipe: SweetImageName.recept6.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish7.rawValue, detailRecipe: SweetImageName.recept7.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish8.rawValue, detailRecipe: SweetImageName.recept8.rawValue, isOpen: false),
                RecipeModel(image: SweetImageName.dish9.rawValue, detailRecipe: SweetImageName.recept9.rawValue, isOpen: false)]
    }
    
    func firstLaunch() {
        if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) == nil {
            UserDefaultsManager.defaults.set(1, forKey: Keys.currentLevel.rawValue)
            collectionItem = defaultRecipes()
            saveCollectionItems()
        }
    }
    
    
    func completeLevel() {
        let currentLevel = UserDefaultsManager.defaults.integer(forKey: Keys.currentLevel.rawValue)
        
        if currentLevel <= 10 {
            UserDefaultsManager.defaults.set(currentLevel + 1, forKey: Keys.currentLevel.rawValue)
        }
    }
    
    func saveCollectionItems() {
        if let encoded = try? JSONEncoder().encode(collectionItem) {
            UserDefaults.standard.set(encoded, forKey: Keys.collectionItem.rawValue)
        }
        
        objectWillChange.send()
    }
    
    func loadCollectionItems() {
        if let savedItems = UserDefaults.standard.data(forKey: Keys.collectionItem.rawValue),
           let decodedItems = try? JSONDecoder().decode([RecipeModel].self, from: savedItems) {
            collectionItem = decodedItems
        } else {
            collectionItem = defaultRecipes()
        }
        
        objectWillChange.send()
    }
    
    func getRandomClosedItem() -> RecipeModel? {
        let item = collectionItem.first(where: { !$0.isOpen })
        if let item = item {
            return item
        } else {
            return RecipeModel(image: SweetImageName.dish1.rawValue, detailRecipe: SweetImageName.recept1.rawValue, isOpen: false)
        }
    }

    func openItem(_ item: RecipeModel) {
        if let index = collectionItem.firstIndex(where: { $0.image == item.image }) {
            var selectedItem = collectionItem[index]
            selectedItem.isOpen = true
            collectionItem[index] = selectedItem
            saveCollectionItems()
        }
    }

}
