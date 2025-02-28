import SwiftUI
import SpriteKit

struct SweetCatchRulesView: View {
    @StateObject var sweetCatchRulesModel =  SweetCatchRulesViewModel()
    var game: SweetGameData
    var scene: SKScene
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                Image(.timeLine)
                    .resizable()
                    .frame(width: geometry.size.width * 0.665, height: geometry.size.height * 0.028)
                    .position(CGPoint(x: geometry.size.width / 1.7,
                                      y: geometry.size.height / 7))
                
                Image(.fruit1)
                    .resizable()
                    .frame(width: geometry.size.width * 0.186, height: geometry.size.height * 0.076)
                    .position(CGPoint(x: geometry.size.width / 1.8,
                                      y: geometry.size.height / 4))
                
                Image(.fruit2)
                    .resizable()
                    .frame(width: geometry.size.width * 0.158, height: geometry.size.height * 0.071)
                    .position(CGPoint(x: geometry.size.width / 3.8,
                                      y: geometry.size.height / 3))
                
                Image(.fruit4)
                    .resizable()
                    .frame(width: geometry.size.width * 0.186, height: geometry.size.height * 0.096)
                    .position(CGPoint(x: geometry.size.width / 3.8,
                                      y: geometry.size.height / 1.4))
                
                VStack {
                    HStack {
                        Button(action: {
                            game.isHelp = false
                            scene.isPaused = false
                        }) {
                            Image(.backButton)
                                .resizable()
                                .frame(width: geometry.size.width * 0.112, height: geometry.size.height * 0.058)
                        }
                        .padding(.leading, geometry.size.width * 0.005)
                        
                        Spacer()
                        
                        Button(action: {
                            game.isHelp = false
                            scene.isPaused = false
                        }) {
                            Image(.pauseButton)
                                .resizable()
                                .frame(width: geometry.size.width * 0.112, height: geometry.size.height * 0.058)
                        }
                        .padding(.trailing, geometry.size.width * 0.01)
                   
                    }
                    .padding(.horizontal)
                    .padding(.top, geometry.size.height * 0.013)
                    
                    Spacer()
                    
                    Text("Ingredients fall into the bowl, but not all of them are needed for the recipe. Swipe left and right to remove unnecessary items, leaving only the right ones. Collect all the right ingredients and your dessert will be ready!")
                        .Puffy(size: 20)
                        .frame(width: geometry.size.width * 0.817)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let game = SweetGameData()
    SweetCatchRulesView(game: game, scene: game.scene)
}
