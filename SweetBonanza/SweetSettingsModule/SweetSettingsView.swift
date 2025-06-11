import SwiftUI

struct SweetSettingsView: View {
    @StateObject var sweetSettingsModel =  SweetSettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
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
                        }
                        
                        Spacer(minLength: geometry.size.height * 0.053)
                        
                        CustomButton(geometry: geometry, text: "SETTINGS")
                        
                        Spacer(minLength: geometry.size.height * 0.2)
                        
                        VStack(spacing: 15) {
                            MusicButton(text: "MUSIC",
                                        image: sweetSettingsModel.musicToggle ? SweetImageName.onToggle.rawValue : SweetImageName.offToggle.rawValue,
                                        geometry: geometry) {
                                sweetSettingsModel.musicToggle.toggle()
                            }
                            
                            MusicButton(text: "SOUND",
                                        image: sweetSettingsModel.soundToggle ? SweetImageName.onToggle.rawValue : SweetImageName.offToggle.rawValue,
                                        geometry: geometry) {
                                sweetSettingsModel.soundToggle.toggle()
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
    SweetSettingsView()
}

