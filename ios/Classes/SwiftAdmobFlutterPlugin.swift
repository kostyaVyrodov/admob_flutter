import Flutter
import UIKit
import GoogleMobileAds

public class SwiftAdmobFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "admob_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftAdmobFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    registrar.register(AdmobBannerFactory(messenger: registrar.messenger()), withId: "admob_flutter/banner")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getPlatformVersion" {
      result("iOS " + UIDevice.current.systemVersion)
    } else if call.method == "initialize" {
      GADMobileAds.configure(withApplicationID: call.arguments as! String)
    }
  }
}
