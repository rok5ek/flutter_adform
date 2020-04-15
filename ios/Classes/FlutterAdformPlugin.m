#import "FlutterAdformPlugin.h"
#if __has_include(<flutteradform/flutteradform-Swift.h>)
#import <flutteradform/flutteradform-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutteradform-Swift.h"
#endif

@implementation FlutterAdformPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAdformPlugin registerWithRegistrar:registrar];
}
@end
