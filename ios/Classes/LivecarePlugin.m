#import "LivecarePlugin.h"
#if __has_include(<livecare/livecare-Swift.h>)
#import <livecare/livecare-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "livecare-Swift.h"
#endif

@implementation LivecarePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLivecarePlugin registerWithRegistrar:registrar];
}
@end
