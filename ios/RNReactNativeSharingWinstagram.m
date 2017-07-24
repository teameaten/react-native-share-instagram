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
#import <Social/Social.h>
#import <Accounts/Accounts.h>

NSString *const kAQSInstagramURLScheme = @"instagram://app";
NSString *const kAQSWhatsappURLScheme = @"whatsapp://app";

@interface RNReactNativeSharingWinstagram () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, assign) BOOL isPerformed;

@end

@implementation RNReactNativeSharingWinstagram

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

-(void)savePicAndOpenInstagram:(NSString*)base64Image {
    UIImage *image = [UIImage imageWithData: [[NSData alloc]initWithBase64EncodedString:base64Image options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    
    if (!image) {
        return;
    }
    
    NSURL *URL = [self nilOrFileURLWithImageDataTemporary:UIImageJPEGRepresentation(image, 0.9)];
    
    __block PHAssetChangeRequest *_mChangeRequest = nil;
    __block PHObjectPlaceholder *placeholder;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        NSData *pngData = [NSData dataWithContentsOfURL:URL];
        UIImage *image = [UIImage imageWithData:pngData];
        
        _mChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        placeholder = _mChangeRequest.placeholderForCreatedAsset;
        
    } completionHandler:^(BOOL success, NSError *error) {
        
        if (success) {
            
            NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?LocalIdentifier=\%@", [placeholder localIdentifier]]];
            
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:nil];
            }
        }
        else {
            NSLog(@"write error : %@",error);
        }
    }];
}

# pragma mark - Helpers (UIDocumentInteractionController)

- (NSURL *)nilOrFileURLWithImageDataTemporary:(NSData *)data {
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.ig"];
    if (![data writeToFile:writePath atomically:YES]) {
        return nil;
    }
    
    return [NSURL fileURLWithPath:writePath];
}

- (UIDocumentInteractionController *)documentInteractionControllerForInstagramWithFileURL:(NSURL *)URL withCaptionText:(NSString *)textOrNil {
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    [controller setUTI:@"com.instagram.exclusivegram"];
    if (textOrNil == nil) {
        textOrNil = @"";
    }
    controller.delegate = self;
    return controller;
}


RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
    return @{
             @"isInstagramInstalled":[[UIApplication sharedApplication] canOpenURL: kAQSInstagramURLScheme] ? @(YES) : @(NO),
             @"isWhatsapppInstalled":[[UIApplication sharedApplication] canOpenURL: kAQSWhatsappURLScheme] ? @(YES) : @(NO),
             @"isTwitterInstalled": [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] ? @(YES) : @(NO),
             @"isFacebookInstalled":[SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ? @(YES) : @(NO),
             };
}


RCT_EXPORT_METHOD(share:(NSString *)base64Image copy:(NSString *)copy andUrl:(NSString *)url) {
    
    UIImage *image = [UIImage imageWithData: [[NSData alloc]initWithBase64EncodedString:base64Image options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    
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

RCT_EXPORT_METHOD(shareOnInstagram:(NSString *)base64Image) {
    if ([[UIApplication sharedApplication] canOpenURL: kAQSInstagramURLScheme]) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusDenied) {
            [self savePicAndOpenInstagram: base64Image];
        }
        else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self savePicAndOpenInstagram: base64Image];
                }
            }];
        }
    }
}

RCT_EXPORT_METHOD(shareOnWhatsapp:copy:(NSString *)copy andUrl:(NSString *)url) {
    if ([[UIApplication sharedApplication] canOpenURL: kAQSWhatsappURLScheme]) {
        copy = [copy stringByAppendingString:@" "];
        copy = [copy stringByAppendingString:url];
        copy = [copy stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", copy]];
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
    }
}

RCT_EXPORT_METHOD(shareOnFacebook:copy:(NSString *)copy andUrl:(NSString *)url) {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPostSheet setInitialText:copy];
        [fbPostSheet addURL:[NSURL URLWithString:url]];
        UIViewController *rootController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootController presentViewController:twPostSheet animated:YES completion:NULL];
    }
}

RCT_EXPORT_METHOD(shareOnTwitter:copy:(NSString *)copy andUrl:(NSString *)url) {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twPostSheet setInitialText:copy];
        [twPostSheet addURL:[NSURL URLWithString:url]];
        
        UIViewController *rootController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootController presentViewController:twPostSheet animated:YES completion:NULL];
    }
}

@end
