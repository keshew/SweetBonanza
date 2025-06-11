import SwiftUI

struct SweetDetailRecipeView: View {
    @StateObject var sweetDetailRecipeModel =  SweetDetailRecipeViewModel()
    @Environment(\.presentationMode) var presentationMode
    var recipe: RecipeModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let selectedImage = UserDefaultsManager().selectedSweetImage() {
                    Image("\(selectedImage)")
                        .resizable()
                        .ignoresSafeArea()
                } else {
                    Image(.mainBack)
                        .resizable()
                        .ignoresSafeArea()
                }
                
                Image(.shadowMain)
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(.backButton)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.115,
                                           height: geometry.size.height * 0.058)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                        
                        Spacer(minLength: geometry.size.height * 0.04)
                        
                        CustomButton(geometry: geometry,
                                     text: "RECIPE")
                        
                        Spacer(minLength: geometry.size.height * 0.04)
                        
                        Image(recipe.detailRecipe)
                            .resizable()
                            .frame(width: 315, height: 500)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SweetDetailRecipeView(recipe: RecipeModel(image: SweetImageName.dish1.rawValue, detailRecipe: SweetImageName.recept1.rawValue, isOpen: true))
}

