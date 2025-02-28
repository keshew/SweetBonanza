import SwiftUI

extension Text {
    func Puffy(size: CGFloat,
                color: Color = .white) -> some View {
            self.font(.custom("Puffy", size: size))
            .foregroundColor(color)
    }
    
    func PuffyOutline(size: CGFloat,
                color: Color = .white,
                    outlineWidth: CGFloat = 1,
                    colorOutline: Color = Color(red: 255/255, green: 0/255, blue: 170/255)) -> some View {
            self.font(.custom("Puffy", size: size))
            .foregroundColor(color)
            .outlineText(color: colorOutline, width: outlineWidth)
    }
}

