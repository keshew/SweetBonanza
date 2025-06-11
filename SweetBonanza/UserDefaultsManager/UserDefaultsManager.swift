import SwiftUI

enum Keys: String {
    case currentLevel = "currentLevel"
    case firstItems = "firstItems"
    case collectionItem = "collectionItem"
    case money = "money"
    case sweetStates = "sweetStates"
}


class UserDefaultsManager: ObservableObject {
    static let defaults = UserDefaults.standard
    
    @Published var collectionItem: [RecipeModel] = []
    @Published var sweetStates: [SweetState] = []
    @Published var images: [String] = []
    
    init() {
        loadCollectionItems()
        loadSweetStates()
        firstLaunch()
    }
    
    static let defaultItems = [
        SweetState(isPurchased: false, isSelected: false, image: "mainBack"),
        SweetState(isPurchased: false, isSelected: false, image: "shopBack1"),
        SweetState(isPurchased: false, isSelected: false, image: "shopBack2")
    ]
    
    private func defaultRecipes() -> [RecipeModel] {
        return [
            RecipeModel(image: SweetImageName.dish1.rawValue, detailRecipe: SweetImageName.recept1.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: SweetImageName.recept2.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish3.rawValue, detailRecipe: SweetImageName.recept3.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish4.rawValue, detailRecipe: SweetImageName.recept4.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish5.rawValue, detailRecipe: SweetImageName.recept5.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish6.rawValue, detailRecipe: SweetImageName.recept6.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish7.rawValue, detailRecipe: SweetImageName.recept7.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish8.rawValue, detailRecipe: SweetImageName.recept8.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish9.rawValue, detailRecipe: SweetImageName.recept9.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish10.rawValue, detailRecipe: SweetImageName.recept10.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish11.rawValue, detailRecipe: SweetImageName.recept11.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish12.rawValue, detailRecipe: SweetImageName.recept12.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish13.rawValue, detailRecipe: SweetImageName.recept13.rawValue, isOpen: false),
            RecipeModel(image: SweetImageName.dish14.rawValue, detailRecipe: SweetImageName.recept14.rawValue, isOpen: false)
        ]
    }
    
    func selectedSweetImage() -> String? {
        return sweetStates.first(where: { $0.isSelected }).map { $0.image }
    }

    func firstLaunch() {
        if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) == nil {
            UserDefaultsManager.defaults.set(1, forKey: Keys.currentLevel.rawValue)
            UserDefaultsManager.defaults.set(500, forKey: Keys.money.rawValue)
            collectionItem = defaultRecipes()
            saveCollectionItems()
            
            sweetStates = UserDefaultsManager.defaultItems
            saveSweetStates()
        }
    }
    
    func handleSweetAction(at index: Int) {
        guard sweetStates.indices.contains(index) else { return }
        
        var currentMoney = UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue)
        
        if !sweetStates[index].isPurchased {
            if currentMoney >= 100 {
                currentMoney -= 100
                UserDefaultsManager.defaults.set(currentMoney, forKey: Keys.money.rawValue)
                
                sweetStates[index].isPurchased = true
                for i in sweetStates.indices {
                    sweetStates[i].isSelected = false
                }
                sweetStates[index].isSelected = true
                
            } else {
                return
            }
        } else if !sweetStates[index].isSelected {
            for i in sweetStates.indices {
                sweetStates[i].isSelected = false
            }
            sweetStates[index].isSelected = true
        }
        
        saveSweetStates()
    }
    
    func completeLevel() {
        let currentLevel = UserDefaultsManager.defaults.integer(forKey: Keys.currentLevel.rawValue)
        let money = UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue)
        
        if currentLevel <= 13 {
            UserDefaultsManager.defaults.set(currentLevel + 1, forKey: Keys.currentLevel.rawValue)
            UserDefaultsManager.defaults.set(money + 100, forKey: Keys.money.rawValue)
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
        if let item = collectionItem.first(where: { !$0.isOpen }) {
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
    
    func saveSweetStates() {
        if let encoded = try? JSONEncoder().encode(sweetStates) {
            UserDefaultsManager.defaults.set(encoded, forKey: Keys.sweetStates.rawValue)
        }
        objectWillChange.send()
    }
    
    func loadSweetStates() {
        if let data = UserDefaultsManager.defaults.data(forKey: Keys.sweetStates.rawValue),
           let decoded = try? JSONDecoder().decode([SweetState].self, from: data) {
            sweetStates = decoded
        } else {
            sweetStates = UserDefaultsManager.defaultItems 
        }
        objectWillChange.send()
    }
}
