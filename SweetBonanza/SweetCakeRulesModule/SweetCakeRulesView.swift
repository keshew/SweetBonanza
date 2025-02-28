import SwiftUI
import SpriteKit

struct SweetCakeRulesView: View {
    @StateObject var sweetCakeRulesModel =  SweetCakeRulesViewModel()
    var game: SweetGameCakeData
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
                
                Image(.cakeDoing1)
                    .resizable()
                    .frame(width: geometry.size.width * 0.824, height: geometry.size.height * 0.408)
                    .position(CGPoint(x: geometry.size.width / 2,
                                      y: geometry.size.height / 1.207))
                
                Image(.getCakeButton)
                    .resizable()
                    .frame(width: geometry.size.width * 0.766, height: geometry.size.height * 0.069)
                    .position(CGPoint(x: geometry.size.width / 2,
                                      y: geometry.size.height / 2.07))
                
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
                    
                    VStack(spacing: geometry.size.height * 0.039) {
                        Text("Watch the indicator light\nand get your dessert out in\ntime so it doesn't burn or\ngo soggy!")
                            .Puffy(size: 20)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.197)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let game = SweetGameCakeData()
    SweetCakeRulesView(game: game, scene: game.scene)
}
