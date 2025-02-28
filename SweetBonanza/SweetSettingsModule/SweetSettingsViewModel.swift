import SwiftUI

class SweetSettingsViewModel: ObservableObject {
    let contact = SweetSettingsModel()
    @Published var musicToggle = true
    @Published var soundToggle = true
}
