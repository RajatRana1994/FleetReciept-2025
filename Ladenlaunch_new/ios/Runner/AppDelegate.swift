import Flutter
import UIKit

//@main
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}
//
//
//import Flutter
//import UIKit
@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
  ) -> Bool {

    let flutterViewController = window?.rootViewController as! FlutterViewController

    let channel = FlutterMethodChannel(
        name: "srgb_converter",
        binaryMessenger: flutterViewController.binaryMessenger
    )

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
        switch call.method {
        case "convertToSRGB":
            guard let path = call.arguments as? String else {
                result(FlutterError(code: "INVALID_PATH", message: "Path missing", details: nil))
                return
            }
            let newPath = ImageSRGB.convertToSRGB(path)
            result(newPath)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

