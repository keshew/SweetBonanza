import SwiftUI
import SpriteKit

struct SweetEggRulesView: View {
    @StateObject var sweetEggRulesModel =  SweetEggRulesViewModel()
    var game: SweetGameEggData
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
                        Text("Press down on the egg and swipe down with your finger to knead the dough for delicious cookie dough. Don't whisk too hard so the shells don't get into the batter!!!!. Watch the scale and stop in the green zone")
                            .Puffy(size: 20)
                            .frame(width: geometry.size.width * 0.817)
                            .multilineTextAlignment(.center)
                        
                        Image(.egg1)
                            .resizable()
                            .frame(width: geometry.size.width * 0.382, height: geometry.size.height * 0.161)
                    }
                    .padding(.top, geometry.size.height * 0.138)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let game = SweetGameEggData()
    SweetEggRulesView(game: game, scene: game.scene)
}
