import SwiftUI

struct SweetMenuView: View {
    @StateObject var sweetMenuModel =  SweetMenuViewModel()

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
                
                Image(.girl)
                    .resizable()
                    .frame(width: geometry.size.width * 0.6,
                           height: geometry.size.height * 0.25)
                    .position(x: geometry.size.width / 1.28, y: geometry.size.height / 1.08)
                
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        Spacer(minLength: geometry.size.height * 0.0)
                        
                        Image(.menuFore)
                            .resizable()
                            .frame(width: 251, height: 251)
                        
                        VStack(spacing: 20) {
                            NavigationLink(destination: SweetLevelView()) {
                                CustomButton2(geometry: geometry,
                                             text: "PLAY")
                            }
                            
                            NavigationLink(destination: SweetSettingsView()) {
                                CustomButton2(geometry: geometry,
                                             text: "SETTINGS", isRight: true)
                            }
                            
                            NavigationLink(destination: SweetRecipeView()) {
                                CustomButton2(geometry: geometry,
                                             text: "RECIPE")
                            }
                            
                            NavigationLink(destination: SweetShopView()) {
                                CustomButton2(geometry: geometry,
                                             text: "SHOP", isRight: true)
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
    SweetMenuView()
}

struct CustomButton: View {
    var geometry: GeometryProxy
    var text: String
    var body: some View {
        ZStack {
            Image(.backForButton)
                .resizable()
                .frame(width: geometry.size.width * 0.662,
                       height: geometry.size.height * 0.084)
            
            Text(text)
                .Puffy(size: 40)
        }
        .frame(width: geometry.size.width * 0.75,
               height: geometry.size.height * 0.087)
    }
}

struct CustomButton2: View {
    var geometry: GeometryProxy
    var text: String
    var isRight = false
    var body: some View {
        ZStack {
            Image(.backForButton)
                .resizable()
                .frame(width: geometry.size.width * 0.662,
                       height: geometry.size.height * 0.084)
            
            Text(text)
                .Puffy(size: 40)
            
            Image(.pie)
                .resizable()
                .frame(width: 60, height: 80)
                .offset(x: isRight ? 120 : -120, y: -5)
        }
        .frame(width: geometry.size.width * 0.75,
               height: geometry.size.height * 0.087)
    }
}
