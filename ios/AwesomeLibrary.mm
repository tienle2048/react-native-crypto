#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(AwesomeLibrary, NSObject)

RCT_EXTERN_METHOD(hdkey:(NSString)a withB:(NSString)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(nacl:(NSString)a withB:(NSString)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
