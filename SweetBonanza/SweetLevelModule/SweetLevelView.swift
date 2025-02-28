import SwiftUI

struct SweetLevelView: View {
    @StateObject var sweetLevelModel =  SweetLevelViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var cachedItem: RecipeModel?
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBack)
                    .resizable()
                    .ignoresSafeArea()
                
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
                        
                        Spacer(minLength: geometry.size.height * 0.053)
                        
                        CustomButton(geometry: geometry, text: "LEVEL'S")
                        
                        Spacer(minLength: geometry.size.height * 0.13)
                        
                        LazyVGrid(columns: sweetLevelModel.gridItem, spacing: 20) {
                            ForEach(0..<9) { index in
                                if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 0 > index {
                                    NavigationLink(destination: SweetGameView(dish: cachedItem ?? RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false))) {
                                        ZStack {
                                            Image(.squareButtonLevel)
                                                .resizable()
                                                .frame(width: geometry.size.width * 0.255,
                                                       height: geometry.size.height * 0.132)
                                            
                                            Text("\(index + 1)")
                                                .Puffy(size: 55)
                                        }
                                    }
                                } else {
                                    ZStack {
                                        Image(.squareButtonLevel)
                                            .resizable()
                                            .frame(width: geometry.size.width * 0.255,
                                                   height: geometry.size.height * 0.132)
                                        
                                        Text("\(index + 1)")
                                            .Puffy(size: 55)
                                    }
                                    .brightness(-0.3)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
                if cachedItem == nil {
                    cachedItem = UserDefaultsManager().getRandomClosedItem()
                }
            }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SweetLevelView()
}

