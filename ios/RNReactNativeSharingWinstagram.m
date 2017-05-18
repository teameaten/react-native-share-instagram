//
//  RNReactNativeSharingWinstagram.h
//  RNReactNativeSharingWinstagram
//
//  Created by Rafael Nascimento on 16/05/17.
//  Copyright © 2017 nascimentorafael. All rights reserved.
//

#import "RNReactNativeSharingWinstagram.h"
#import "RCTBridge.h"

@implementation RNReactNativeSharingWinstagram

NSString* const kInstagramAppURLString = @"instagram://app";
NSString* const kInstagramOnlyPhotoFileName = @"tempinstgramphoto.igo";

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport {
    NSURL *appURL = [NSURL URLWithString:kInstagramAppURLString];
    return @{
             @"canShareToInstagram": [[UIApplication sharedApplication] canOpenURL:appURL] ? @(NO) : @(YES)
             };
}

RCT_EXPORT_METHOD(shareToInstagramImageEndodedWith:(NSString *)base64String) {
    NSString *photoFilePath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],kInstagramOnlyPhotoFileName];
    
    UIImage *image = [UIImage imageWithData: [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    
    if (!image) {
        return;
    }
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:photoFilePath atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:photoFilePath];
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentInteractionController.delegate = self;
    self.documentInteractionController.UTI = @"com.instagram.exclusivegram";
    
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [self.documentInteractionController presentOpenInMenuFromRect:ctrl.view.bounds inView:ctrl.view animated:YES];
}

RCT_EXPORT_METHOD(shareText:(NSString *)text withUrl:(NSString *)url) {
    NSString *textToShare = text;
    NSURL *urlToShare = [NSURL URLWithString:url];
    
    NSArray *objectsToShare = @[textToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:activityVC animated:YES completion:nil];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

@end
