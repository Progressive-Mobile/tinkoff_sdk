#import "TinkoffSdkPlugin.h"
#if __has_include(<tinkoff_sdk/tinkoff_sdk-Swift.h>)
#import <tinkoff_sdk/tinkoff_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tinkoff_sdk-Swift.h"
#endif

@implementation TinkoffSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTinkoffSdkPlugin registerWithRegistrar:registrar];
}
@end
