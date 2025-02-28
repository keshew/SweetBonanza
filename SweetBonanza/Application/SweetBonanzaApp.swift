import SwiftUI

@main
struct SweetBonanzaApp: App {
    var body: some Scene {
        WindowGroup {
            SweetLoadingView()
                .onAppear() {
                    UserDefaultsManager().firstLaunch()
                }
        }
    }
}
