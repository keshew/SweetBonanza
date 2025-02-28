import SwiftUI
import SpriteKit

struct SweetFillRulesView: View {
    @StateObject var sweetFillRulesModel =  SweetFillRulesViewModel()
    var game: SweetGameFillData
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
                
                ZStack {
                    Image(.desk)
                        .resizable()
                        .frame(width: geometry.size.width * 0.918, height: geometry.size.height * 0.185)
                        
                    HStack {
                        Image(.cupcake2)
                            .resizable()
                            .frame(width: geometry.size.width * 0.166, height: geometry.size.height * 0.083)
                        
                        Image(.cupcake4)
                            .resizable()
                            .frame(width: geometry.size.width * 0.166, height: geometry.size.height * 0.083)
                        
                        Image(.cupcake3)
                            .resizable()
                            .frame(width: geometry.size.width * 0.166, height: geometry.size.height * 0.083)
                        
                        Image(.cupcake1)
                            .resizable()
                            .frame(width: geometry.size.width * 0.166, height: geometry.size.height * 0.083)
                    }
                    .offset(y: -geometry.size.height * 0.008)
                }
                .position(CGPoint(x: geometry.size.width / 2,
                                  y: geometry.size.height / 1.13))
                
                Image(.fillItem)
                    .resizable()
                    .frame(width: geometry.size.width * 0.382, height: geometry.size.height * 0.23)
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
                    
                    VStack {
                        HStack {
                            Text("Fill the molds with dough,\nstopping in time so you\ndon't overfill or leave\nthem empty!")
                                .Puffy(size: 20)
                                .padding(.leading)
                            Spacer()
                            
                            Image(.deskFillItem)
                                .resizable()
                                .frame(width: geometry.size.width * 0.229, height: geometry.size.height * 0.165)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.132)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let game = SweetGameFillData()
    SweetFillRulesView(game: game, scene: game.scene)
}
