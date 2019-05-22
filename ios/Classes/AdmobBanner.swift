import Foundation
import Flutter
import GoogleMobileAds

public class AdmobBanner : NSObject, FlutterPlatformView, GADBannerViewDelegate {
    private let messenger: FlutterBinaryMessenger
    private let channel: FlutterMethodChannel

    private let adView = GADBannerView(adSize: kGADAdSizeBanner)

    init(messenger: FlutterBinaryMessenger, viewId: Int64, args: Any?) {
        self.messenger = messenger
        self.channel = FlutterMethodChannel(name: "admob_flutter/banner_\(viewId)", binaryMessenger: messenger)

        super.init()

        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            adView.adUnitID = (args as! [String: Any?])["adUnitId"] as? String
            adView.rootViewController = topController
            adView.load(GADRequest())
        }

        channel.setMethodCallHandler(handleMethodCall)
    }
    
    public func view() -> UIView {
        return adView
    }
    
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        channel.invokeMethod("loaded", arguments: nil)
    }
    
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        channel.invokeMethod("failedToLoad", arguments: ["errorCode": error.code])
    }
    
    private func handleMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        if call.method == "setListener" {
            adView.delegate = self
        } else if call.method == "dispose" {
            adView.delegate = nil
            channel.setMethodCallHandler(nil)
        }
    }
}
