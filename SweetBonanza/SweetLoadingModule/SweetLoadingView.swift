import SwiftUI

struct SweetLoadingView: View {
    @StateObject var sweetLoadingModel =  SweetLoadingViewModel()
    
    var body: some View {
        NavigationView {
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
                    
                    VStack {
                        Text(sweetLoadingModel.currentText)
                            .PuffyOutline(size: 50,
                                          color: Color(red: 255/255, green: 0/255, blue: 170.255),
                                          outlineWidth: 0.8,
                                          colorOutline: .white)
                            .offset(y: geometry.size.height * 0.106)
                    }
                }
                .onAppear {
                    sweetLoadingModel.startTimer()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.sweetLoadingModel.isMenu = true
                    }
                }
                
                NavigationLink(destination: SweetMenuView(),
                               isActive: $sweetLoadingModel.isMenu) {}
                .hidden()
            }
        }
    }
}

#Preview {
    SweetLoadingView()
}

