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

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(shareImage:(NSString *)base64String copy:(NSString *)copy andUrl:(NSString *)url) {
    
    UIImage *image = [UIImage imageWithData: [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    
    if (!image) {
        return;
    }
    
    AQSInstagramActivity *activity = [[AQSInstagramActivity alloc] init];
    NSArray *items = @[copy, [[NSURL alloc]initWithString:url], image];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:@[activity]];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard, UIActivityTypeOpenInIBooks];
    
    UIViewController *rootController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [rootController presentViewController:activityController animated:YES completion:NULL];
    
}

@end
