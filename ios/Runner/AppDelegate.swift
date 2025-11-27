import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
  ) -> Bool {

    // Google Maps
    GMSServices.provideAPIKey("AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I")

    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Firebase initialization
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }

    // Facebook SDK initialization (mandatory)
    ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
    )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // REQUIRED for Facebook + Google Sign-In + UniLinks to work
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    // Facebook URL handling
    if ApplicationDelegate.shared.application(app, open: url, options: options) {
        return true
    }

    // Google Sign-in
    if GIDSignIn.sharedInstance.handle(url) {
        return true
    }

    // Flutter deep links (uni_links)
    return super.application(app, open: url, options: options)
  }
}
