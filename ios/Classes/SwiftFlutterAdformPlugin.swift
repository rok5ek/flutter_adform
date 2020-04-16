import Flutter
import UIKit
import AdformAdvertising

public class SwiftFlutterAdformPlugin: NSObject, FlutterPlugin {
    
    static let ADFORM_METHOD_CHANNEL = "flutter_adform"
    static let ADFORM_ADINLINE_VIEW_TYPE = "flutter_adform/adInline"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: ADFORM_METHOD_CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAdformPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        registrar.register(AdformAdInlineFactory(messenger: registrar.messenger()), withId: ADFORM_ADINLINE_VIEW_TYPE)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS" + UIDevice.current.systemVersion)
    }
}

