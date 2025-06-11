import SwiftUI

struct SweetWinView: View {
    @StateObject var sweetWinModel =  SweetWinViewModel()
    @State private var cachedItem: RecipeModel?
    let dish: RecipeModel
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Image(.win)
                            .resizable()
                            .frame(width: geometry.size.width * 0.875,
                                   height: 266)
                        
                        Image(dish.image)
                            .resizable()
                            .frame(width: geometry.size.width * 0.178,
                                   height: geometry.size.height * 0.092)
                            .offset(x: -geometry.size.width * 0.255,
                                     y: geometry.size.height * 0.053)
                        
                        Image("money")
                            .resizable()
                            .frame(width: geometry.size.width * 0.128,
                                   height: geometry.size.height * 0.025)
                            .offset(x: -geometry.size.width * 0.06,
                                     y: geometry.size.height * 0.09)
                        
                        HStack(spacing: 2) {
                            NavigationLink(destination: SweetMenuView()) {
                                ZStack {
                                    Image(.backForButton)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.395,
                                               height: geometry.size.height * 0.061)
                                    
                                    Text("TO MENU")
                                        .Puffy(size: 25)
                                }
                            }
                            
                            NavigationLink(destination: SweetGameView(dish: cachedItem ?? RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false))) {
                                ZStack {
                                    Image(.backForButton)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.395,
                                               height: geometry.size.height * 0.061)
                                    
                                    Text("NEXT")
                                        .Puffy(size: 25)
                                }
                            }
                        }
                        .offset(y: geometry.size.height * 0.142)
                    }
                }
            }
            .onAppear {
                UserDefaultsManager().openItem(dish)
                UserDefaultsManager().completeLevel()
                if cachedItem == nil {
                    cachedItem = UserDefaultsManager().getRandomClosedItem()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let dish = RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false)
    SweetWinView(dish: dish)
}
