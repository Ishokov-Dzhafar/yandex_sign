#import "YandexSignPlugin.h"
#import <yandex_sign/yandex_sign-Swift.h>

@implementation YandexSignPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYandexSignPlugin registerWithRegistrar:registrar];
}
@end
