import SwiftUI

class SweetShopViewModel: ObservableObject {
    let contact = SweetShopModel()
    @Published var again = 0
}
