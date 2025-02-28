import SwiftUI

struct CustomButton: View {
    var geometry: GeometryProxy
    var text: String
    var body: some View {
        ZStack {
            Image(.backForButton)
                .resizable()
                .frame(width: geometry.size.width * 0.662,
                       height: geometry.size.height * 0.103)
            
            Text(text)
                .Puffy(size: 45)
        }
    }
}

struct MusicButton: View {
    var text: String
    var image: String
    var geometry: GeometryProxy
    var action: (() -> ())
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Image(.backForButton)
                    .resizable()
                
                HStack {
                    Text(text)
                        .Puffy(size: 33)
                        .offset(y: 2)
                    
                    Spacer()
                    
                    Image(image)
                        .resizable()
                        .frame(width: geometry.size.width * 0.072,
                               height: geometry.size.height * 0.037)
                }
                .padding(.horizontal, geometry.size.width * 0.078)
            }
        }
        .frame(width: geometry.size.width * 0.555,
               height: geometry.size.height * 0.0831)
    }
}

struct SmallButton: View {
    var geometry: GeometryProxy
    var text: String
    var body: some View {
        ZStack {
            Image(.backForButton)
                .resizable()
                .frame(width: geometry.size.width * 0.555,
                       height: geometry.size.height * 0.0831)
            
            Text(text)
                .Puffy(size: 33)
        }
    }
}
