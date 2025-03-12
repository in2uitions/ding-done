import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {

  override init() {
    super.init()
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I")
    GeneratedPluginRegistrant.register(with: self)

    // Ensure Firebase is configured first
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
