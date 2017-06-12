//
//  RNReactNativeSharingWinstagram.h
//  RNReactNativeSharingWinstagram
//
//  Created by Rafael Nascimento on 16/05/17.
//  Copyright © 2017 nascimentorafael. All rights reserved.
//

#import "RNReactNativeSharingWinstagram.h"
#import "RCTBridge.h"
#import "AQSInstagramActivity.h"

@implementation RNReactNativeSharingWinstagram

NSString* const kInstagramAppURLString = @"instagram://app";
NSString* const kInstagramOnlyPhotoFileName = @"tempinstgramphoto.igo";

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(shareImage:(NSString *)image Url(NSString *)url andCopy(NSString *)copy) {
    
    UIImage *image = [UIImage imageWithData: [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    
    if (!image) {
        return;
    }

    AQSInstagramActivity *activity = [[AQSInstagramActivity alloc] init];
    NSArray *items = @[[[NSURL alloc]initWithString:url],copy, image];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:@[activity]];
    
    UIViewController *rootController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [rootController presentViewController:activityController animated:YES completion:NULL];
    
}

@end
