import SwiftUI
import SpriteKit

struct SweetShakeRulesView: View {
    @StateObject var sweetShakeRulesModel =  SweetShakeRulesViewModel()
    var game: SweetGameShakeData
    var scene: SKScene
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                Image(.timeLine)
                    .resizable()
                    .frame(width: geometry.size.width * 0.665,
                           height: geometry.size.height * 0.028)
                    .position(CGPoint(x: geometry.size.width / 1.7,
                                      y: geometry.size.height / 7))
                
                Image(.shakeBowl2)
                    .resizable()
                    .frame(width: geometry.size.width * 0.712,
                           height: geometry.size.height * 0.287)
                    .position(CGPoint(x: geometry.size.width / 2,
                                      y: geometry.size.height / 1.1075))
                
                Image(.whisk2)
                    .resizable()
                    .frame(width: geometry.size.width * 0.382,
                           height: geometry.size.height * 0.23)
                    .position(CGPoint(x: geometry.size.width / 1.4,
                                      y: geometry.size.height / 1.5))
                
                VStack {
                    HStack {
                        Button(action: {
                            game.isHelp = false
                            scene.isPaused = false
                        }) {
                            Image(.backButton)
                                .resizable()
                                .frame(width: geometry.size.width * 0.112,
                                       height: geometry.size.height * 0.058)
                        }
                        .padding(.leading, geometry.size.width * 0.005)
                        
                        Spacer()
                        
                        Button(action: {
                            game.isHelp = false
                            scene.isPaused = false
                        }) {
                            Image(.pauseButton)
                                .resizable()
                                .frame(width: geometry.size.width * 0.112,
                                       height: geometry.size.height * 0.058)
                        }
                        .padding(.trailing, geometry.size.width * 0.01)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, geometry.size.height * 0.013)
                    
                    
                    VStack(spacing: geometry.size.height * 0.039) {
                        Text("Knead the dough!")
                            .Puffy(size: 20)
                        
                        Text("Turn the whisk in a circular\nmotion on the screen.\nWatch the indicator: the dough\nmust be perfect!")
                            .Puffy(size: 20)
                            .multilineTextAlignment(.center)
                        
                        Text("Red - too thick.\nYellow - liquid.\nGreen - perfect.")
                            .Puffy(size: 20)
                            .multilineTextAlignment(.center)
                        
                        Text("Stop the indicator in the right\nzone!!!")
                            .Puffy(size: 20)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.145)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let game = SweetGameShakeData()
    SweetShakeRulesView(game: game, scene: game.scene)
}
