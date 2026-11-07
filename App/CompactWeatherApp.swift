import SwiftUI
import WidgetKit

@main
struct CompactWeatherApp: App {
    @State private var location = LocationPermission()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            WeatherPage()
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active else { return }
            location.requestIfNeeded()
            // Faces keep a cached drawing until the next scheduled refresh (up to 30 min);
            // opening the app redraws the complication, e.g. right after installing a new build.
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
