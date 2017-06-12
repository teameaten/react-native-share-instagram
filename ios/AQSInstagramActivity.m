//
//  AQSInstagramActivity.m
//  AQSInstagramActivity
//
//  Created by Rafael Nascimento on 16/05/17.
//  Copyright © 2017 nascimentorafael. All rights reserved.
//

#import "AQSInstagramActivity.h"
@import Photos;

NSString *const kAQSInstagramURLScheme = @"instagram://app";

@interface AQSInstagramActivity () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, assign) BOOL isPerformed;

@end

@implementation AQSInstagramActivity

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    [super prepareWithActivityItems:activityItems];
    
    self.activityItems = activityItems;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityTitle {
    return @"Instagram";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Instagram_icon"]];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return [self isInstagramInstalled] && [self nilOrFirstImageFromArray:activityItems] != nil;
}

- (void)performActivity {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusDenied) {
        [self savePicAndOpenInstagram];
    }
    else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self savePicAndOpenInstagram];
            }
        }];
    }
}

# pragma mark - Helpers (Instagram)

- (BOOL)isInstagramInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kAQSInstagramURLScheme]];
}

- (void)savePicAndOpenInstagram {
    UIImage *image = [self nilOrFirstImageFromArray:_activityItems];
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
        [self activityDidFinish:NO];
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

# pragma mark - Helpers (View)

- (UIView *)currentView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController.view;
}

# pragma mark - Helpers (UIActivity)

- (NSString *)firstStringOrEmptyStringFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[NSString class]]) {
            return item;
        }
    }
    return @"";
}

- (UIImage *)nilOrFirstImageFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[UIImage class]]) {
            return item;
        }
    }
    return nil;
}

# pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    if ([application isEqualToString:@"com.burbn.instagram"]) {
        self.isPerformed = YES;
    }
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    [self activityDidFinish:self.isPerformed];
}

@end
