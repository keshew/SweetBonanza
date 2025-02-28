import SwiftUI
import SpriteKit

struct SweetPauseView: View {
    @StateObject var sweetPauseModel =  SweetPauseViewModel()
    @Binding var isPause: Bool
    var scene: SKScene
    var dish: RecipeModel
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer(minLength: geometry.size.height * 0.198)
                        
                        CustomButton(geometry: geometry, text: "PAUSE")
                        
                        Spacer(minLength: geometry.size.height * 0.133)
                        
                        VStack(spacing: 20) {
                            Button(action: {
                                scene.isPaused = false
                                isPause = false
                            }) {
                                SmallButton(geometry: geometry, text: "CONTINUE")
                            }
                            
                            NavigationLink(destination: SweetGameView(dish: dish)) {
                                SmallButton(geometry: geometry, text: "REstart")
                            }
                            
                            NavigationLink(destination: SweetMenuView()) {
                                SmallButton(geometry: geometry, text: "To menu")
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
    let scene = SKScene()
    let dish = RecipeModel(image: SweetImageName.dish2.rawValue, detailRecipe: "", isOpen: false)
    SweetPauseView(isPause: .constant(false), scene: scene, dish: dish)
}

