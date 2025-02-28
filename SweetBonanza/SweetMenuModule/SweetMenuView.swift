import SwiftUI

struct SweetMenuView: View {
    @StateObject var sweetMenuModel =  SweetMenuViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBack)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.shadowMain)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.girl)
                    .resizable()
                    .frame(width: geometry.size.width * 0.899,
                           height: geometry.size.height * 0.383)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.15)
                
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer(minLength: geometry.size.height * 0.277)
                        
                        NavigationLink(destination: SweetLevelView()) {
                            CustomButton(geometry: geometry,
                                         text: "PLAY")
                        }
                        
                        NavigationLink(destination: SweetSettingsView()) {
                            CustomButton(geometry: geometry,
                                         text: "SETTINGS")
                        }
                        
                        NavigationLink(destination: SweetRecipeView()) {
                            CustomButton(geometry: geometry,
                                         text: "RECIPE")
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

