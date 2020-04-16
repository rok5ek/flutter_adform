import Flutter
import Foundation
import AdformAdvertising

class AdformAdInline : NSObject, FlutterPlatformView {

    private let channel: FlutterMethodChannel
    private let messenger: FlutterBinaryMessenger
    private let frame: CGRect
    private let viewId: Int64
    private let args: [String: Any]
    private var adView: AFAdInline?
    
    static let DISPOSE = "dispose";
    static let ARG_MASTER_TAG_ID = "masterTagId";
    static let ARG_WIDTH = "width";
    static let ARG_HEIGHT = "height";

    init(frame: CGRect, viewId: Int64, args: [String: Any], messenger: FlutterBinaryMessenger) {
        self.args = args
        self.messenger = messenger
        self.frame = frame
        self.viewId = viewId
        channel = FlutterMethodChannel(name: "\(SwiftFlutterAdformPlugin.ADFORM_ADINLINE_VIEW_TYPE)_\(viewId)", binaryMessenger: messenger)
    }
    
    func view() -> UIView {
        return getOrSetupBannerAdView()
    }

    private func dispose() {
        adView?.removeFromSuperview()
        adView = nil
        channel.setMethodCallHandler(nil)
    }
    
    private func getOrSetupBannerAdView() -> AFAdInline {
        if let adView = adView {
            return adView
        }

        let masterTagId = args[AdformAdInline.ARG_MASTER_TAG_ID] as? Int ?? 0
        let width = args[AdformAdInline.ARG_WIDTH] as? Int ?? 0
        let height = args[AdformAdInline.ARG_HEIGHT] as? Int ?? 0
        let adSize: CGSize = CGSize(width: width, height: height)
        let uiViewController = UIApplication.shared.keyWindow!.rootViewController!
        
        let adView = AFAdInline(masterTagId: masterTagId, presenting: uiViewController, adSize: adSize)
        adView.loadAd()
        self.adView = adView
        
        channel.setMethodCallHandler { [weak self] (flutterMethodCall: FlutterMethodCall, flutterResult: FlutterResult) in
            switch flutterMethodCall.method {
            case AdformAdInline.DISPOSE:
                self?.dispose()
            default:
                flutterResult(FlutterMethodNotImplemented)
            }
        }

        return adView
    }
}
