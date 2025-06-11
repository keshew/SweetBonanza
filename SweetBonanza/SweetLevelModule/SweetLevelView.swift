import SwiftUI

struct SweetLevelView: View {
    @StateObject var sweetLevelModel =  SweetLevelViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var cachedItem: RecipeModel?
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
                
                Image(.left)
                    .resizable()
                    .frame(width: geometry.size.width * 0.589,
                           height: geometry.size.height * 0.209)
                    .position(x: geometry.size.width / 4.5,
                              y: geometry.size.height / 1.06)

                Image(.trailing)
                    .resizable()
                    .frame(width: geometry.size.width * 0.463,
                           height: geometry.size.height * 0.194)
                    .position(x: geometry.size.width / 1.2,
                              y: geometry.size.height / 1.065)

                Image(.middle)
                    .resizable()
                    .frame(width: geometry.size.width * 0.373,
                           height: geometry.size.height * 0.126)
                    .position(x: geometry.size.width / 1.3,
                              y: geometry.size.height / 1.02)

                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ZStack {
                            Image(.levels)
                                .resizable()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.195)
                            
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
                        }
                            
                        Spacer(minLength: geometry.size.height * 0.03)
                        
                        LazyVGrid(columns: sweetLevelModel.gridItem, spacing: 20) {
                            ForEach(0..<14) { index in
                                if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 0 > index {
                                    if index == 12 || index == 13 {
                                        NavigationLink(destination: SweetGameView(dish: cachedItem ?? RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false))) {
                                            ZStack {
                                                Image("\(index + 1)")
                                                    .resizable()
                                                    .frame(width: geometry.size.width * 0.22,
                                                           height: geometry.size.height * 0.12)
                                            }
                                            .padding(.leading, geometry.size.width * 0.348)
                                        }
                                    } else {
                                        NavigationLink(destination: SweetGameView(dish: cachedItem ?? RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false))) {
                                            ZStack {
                                                Image("\(index + 1)")
                                                    .resizable()
                                                    .frame(width: geometry.size.width * 0.22,
                                                           height: geometry.size.height * 0.12)
                                            }
                                        }
                                    }
                               
                                } else {
                                    if index == 12 || index == 13 {
                                        ZStack {
                                            Image("\(index + 1)")
                                                .resizable()
                                                .frame(width: geometry.size.width * 0.22,
                                                       height: geometry.size.height * 0.12)
                                        }
                                        .brightness(-0.3)
                                        .padding(.leading, geometry.size.width * 0.348)
                                    } else {
                                        ZStack {
                                            Image("\(index + 1)")
                                                .resizable()
                                                .frame(width: geometry.size.width * 0.22,
                                                       height: geometry.size.height * 0.12)
                                        }
                                        .brightness(-0.3)
                                    }
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

