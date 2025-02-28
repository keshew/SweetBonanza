import SwiftUI

struct SweetLoseLateView: View {
    @StateObject var sweetLoseLateModel =  SweetLoseLateViewModel()
    let dish: RecipeModel
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Image(.loseLate)
                            .resizable()
                            .frame(width: geometry.size.width * 0.875,
                                   height: geometry.size.height * 0.285)
                        
                        HStack(spacing: geometry.size.width * 0.013) {
                            NavigationLink(destination: SweetMenuView()) {
                                ZStack {
                                    Image(.backForButton)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.382,
                                               height: geometry.size.height * 0.061)
                                    
                                    Text("TO MENU")
                                        .Puffy(size: 25)
                                }
                            }
                            
                            NavigationLink(destination: SweetGameView(dish: dish)) {
                                ZStack {
                                    Image(.backForButton)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.382,
                                               height: geometry.size.height * 0.061)
                                    
                                    Text("RESTART")
                                        .Puffy(size: 25)
                                }
                            }
                        }
                        .offset(y: geometry.size.height * 0.079)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let dish = RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false)
    SweetLoseLateView(dish: dish)
}
