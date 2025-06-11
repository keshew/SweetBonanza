import SwiftUI

struct SweetRecipeView: View {
    @StateObject var sweetRecipeModel =  SweetRecipeViewModel()
    @Environment(\.presentationMode) var presentationMode
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
                        
                        Spacer(minLength: geometry.size.height * 0.08)
                        
                        CustomButton(geometry: geometry,
                                     text: "RECIPE")
                        
                        Spacer(minLength: geometry.size.height * 0.08)
                        
                        ZStack {
                            Image(.recipesBack)
                                .resizable()
                                .frame(width: geometry.size.width * 0.853,
                                       height: geometry.size.height * 0.644)
                            
                            LazyVGrid(columns: sweetRecipeModel.gridItem, spacing: geometry.size.width * 0.051) { 
                                ForEach(sweetRecipeModel.recipes.indices, id: \.self) { index in
                                    if sweetRecipeModel.recipes[index].isOpen {
                                        NavigationLink(destination: SweetDetailRecipeView(recipe: sweetRecipeModel.recipes[index])) {
                                            Image(sweetRecipeModel.recipes[index].image)
                                                .resizable()
                                                .frame(width: geometry.size.width * 0.188,
                                                       height: geometry.size.width * 0.188)
                                         
                                        }
                                        .padding(.leading, (index == 12 || index == 13) ? UIScreen.main.bounds.width * (100 / 408) : 0)
                                    } else {
                                        ZStack {
                                            Image(sweetRecipeModel.recipes[index].image)
                                                .resizable()
                                                .frame(width: geometry.size.width * 0.188,
                                                       height: geometry.size.width * 0.188)
                                            
                                            Color.black
                                                .opacity(0.4)
                                                .frame(width: geometry.size.width * 0.188,
                                                       height: geometry.size.width * 0.188)
                                                .cornerRadius(geometry.size.width * 0.069)
                                        }
                                        .overlay {
                                            RoundedRectangle(cornerRadius: geometry.size.width * 0.059)
                                                .stroke(.white, lineWidth: geometry.size.width * 0.0076)
                                                .frame(width: geometry.size.width * 0.18,
                                                       height: geometry.size.height * 0.095)
                                        }
                                        .padding(.leading, (index == 12 || index == 13) ? UIScreen.main.bounds.width * (100 / 408) : 0)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SweetRecipeView()
}
