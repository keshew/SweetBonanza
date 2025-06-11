import SwiftUI

struct SweetShopView: View {
    @StateObject var sweetShopModel =  SweetShopViewModel()
    @State var currentIndex = 0
    @Environment(\.presentationMode) var presentationMode
    @State var userDefaultsManager = UserDefaultsManager()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let selectedImage = userDefaultsManager.selectedSweetImage() {
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
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(.backButton)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.115,
                                           height: geometry.size.height * 0.058)
                            }
                            .padding(.leading)
                            
                            Spacer()
                            
                            Image(.moneyBack)
                                .resizable()
                                .overlay {
                                    HStack(spacing: 4) {
                                        Text("\(UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue))")
                                            .Puffy(size: 18, color: Color(red: 255/255, green: 196/255, blue: 28/255))
                                            .offset(y: 2)
                                        
                                        Image(.coin)
                                            .resizable()
                                            .frame(width: 11, height: 17)
                                    }
                                }
                                .frame(width: 69, height: 42)
                                .padding(.trailing)
                            
                        }
                        
                        Spacer(minLength: geometry.size.height * 0.053)
                        
                        CustomButton(geometry: geometry, text: "SHOP")
                        
                        HStack(spacing: 25) {
                            Button(action: {
                                guard currentIndex >= 1 else { return }
                                currentIndex -= 1
                            }) {
                                Image(.leftBtn)
                                    .resizable()
                                    .frame(width: 31, height: 34)
                            }
                            
                            if userDefaultsManager.sweetStates.indices.contains(currentIndex) {
                                Image(userDefaultsManager.sweetStates[currentIndex].image)
                                    .resizable()
                                    .frame(width: 223, height: 398)
                                    .cornerRadius(25)
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(red: 255/255, green: 0/255, blue: 171/255), lineWidth: 4)
                                    })
                                    .padding(.top, 50)
                            }
                            
                            Button(action: {
                                guard currentIndex <= 1 else { return }
                                currentIndex += 1
                            }) {
                                Image(.rightBtn)
                                    .resizable()
                                    .frame(width: 31, height: 34)
                            }
                        }
                       
                        Button(action: {
                            userDefaultsManager.handleSweetAction(at: currentIndex)
                            sweetShopModel.again = 3
                        }) {
                            let state = userDefaultsManager.sweetStates[currentIndex]
                            Image(
                                !state.isPurchased ? "buy" :
                                (state.isSelected ? "selected" : "select")
                            )
                            .resizable()
                            .frame(width: 230, height: 60)
                        }
                        .padding(.top, 30)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SweetShopView()
}

