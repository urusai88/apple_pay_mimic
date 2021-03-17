#import "ApplePayMimicPlugin.h"
#if __has_include(<apple_pay_mimic/apple_pay_mimic-Swift.h>)
#import <apple_pay_mimic/apple_pay_mimic-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "apple_pay_mimic-Swift.h"
#endif

@implementation ApplePayMimicPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftApplePayMimicPlugin registerWithRegistrar:registrar];
}
@end
